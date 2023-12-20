import java.nio.file.*;
import java.util.*;
import java.math.*;

class Signal {
  public String from;
  public String to;
  public boolean high;

  public Signal(String from, String to, boolean high) {
    this.from = from;
    this.to = to;
    this.high = high;
  }
}

abstract class Module {
  String name;
  List<String> outputs;
  List<String> inputs;

  public Module(String name) {
    this.name = name;
    this.outputs = new ArrayList<String>();
    this.inputs = new ArrayList<String>();
  }

  void processSignal(Signal s, Queue<Signal> q) {}

  void registerOutput(String m) {
    outputs.add(m);
  }

  void registerInput(String m) {
    inputs.add(m);
  }
}

class BroadcasterModule extends Module {
  public BroadcasterModule(String name) { super(name); }

  void processSignal(Signal s, Queue<Signal> q) {
    for (String output : outputs) {
      q.add(new Signal(name, output, s.high));
    }
  }
}

class FlipFlopModule extends Module {
  boolean state = false;

  public FlipFlopModule(String name) { super(name); }

  void processSignal(Signal s, Queue<Signal> q) {
    if (s.high) return; 
    this.state = !state;
    for (String output : outputs) {
      q.add(new Signal(name, output, state));
    }
  }
}

class ConjunctionModule extends Module {
  HashMap<String,Boolean> state;

  public ConjunctionModule(String name) { 
    super(name);
    this.state = new HashMap<String,Boolean>();
  }

  void processSignal(Signal s, Queue<Signal> q) {
    state.put(s.from, s.high);
    boolean allHigh = true;
    for (String input : this.inputs) {
      allHigh = allHigh && state.getOrDefault(input, false);
    }
    for (String output : outputs) {
      q.add(new Signal(name, output, !allHigh));
    }
  }
}

@FunctionalInterface
interface SignalAction {
  void perform(Signal signal);
}

public class Main {
  private static HashMap<String,Module> modules;
  private static LinkedList<Signal> queue;
  private static final String BUTTON = "button";
  private static final String BROADCASTER = "broadcaster";
  private static final String FLIP_FLOP_PREFIX = "%";
  private static final String CONJUNCTION_PREFIX = "&";
  private static final String[] COMPONENT_MODULES = {"mk", "fp", "xt", "zc"};
  private static final String INVERTER_MODULE = "kl";


  public static void main(String[] args) throws Exception {
    modules = new HashMap<String,Module>();
    queue = new LinkedList<Signal>();
    parseModules(args[0]);
    if(args[1].equals("1")) runPart1();
    else runPart2();
  }

  static void runPart1() {
    final int[] counters = {0, 0};
    for (int i = 0; i < 1000; i++) pressButton(signal -> counters[signal.high ? 0 : 1]++);
    System.out.println(counters[0] * counters[1]);
  }

  static void runPart2() {
    HashMap<String, Integer> values = new HashMap<>();
    for (String module : COMPONENT_MODULES) values.put(module, 0);
    final int[] i = {1};
    while (values.containsValue(0)) {
      pressButton(signal -> {
        if (signal.to.equals(INVERTER_MODULE) && values.containsKey(signal.from) && signal.high) {
          values.put(signal.from, i[0]);
        }
      });
      i[0]++;
    }
    long result = 1;
    for (String module : COMPONENT_MODULES) result *= values.get(module);
    System.out.println(result);
  }

  static void pressButton(SignalAction action) {
    queue.add(new Signal(BUTTON, BROADCASTER, false));
    while (queue.peekFirst() != null) {
      Signal s = queue.pop();
      action.perform(s);
      modules.get(s.to).processSignal(s, queue);
    }
  }

  static void parseModules(String file) throws Exception {
    Path filePath = Paths.get(file);
    List<String> lines = Files.readAllLines(filePath);
    for (String line : lines) makeOrGet(line.split(" -> ")[0]);
    for (String line : lines) {
      String[] sections = line.split(" -> ");
      Module srcModule = makeOrGet(sections[0]);
      for (String dest : sections[1].split(", ")) {
        Module dstModule = makeOrGet(dest);
        srcModule.registerOutput(dest.replace("%","").replace("&",""));
        dstModule.registerInput(sections[0].replace("%","").replace("&",""));
      }
    }
  }

  static Module makeOrGet(String name) {
    String cleanName = cleanModuleName(name);
    if (!modules.containsKey(cleanName)) {
      switch(getModuleType(name)) {
        case FLIP_FLOP_PREFIX:
          modules.put(cleanName, new FlipFlopModule(cleanName));
          break;
        case CONJUNCTION_PREFIX:
          modules.put(cleanName, new ConjunctionModule(cleanName));
          break;
        default:
          modules.put(cleanName, new BroadcasterModule(cleanName));
      }
    }
    return modules.get(cleanName);
  }

  static String cleanModuleName(String name) {
    return name.replace(FLIP_FLOP_PREFIX, "")
               .replace(CONJUNCTION_PREFIX, "");
  }

  static String getModuleType(String name) {
    if (name.startsWith(FLIP_FLOP_PREFIX)) return FLIP_FLOP_PREFIX;
    if (name.startsWith(CONJUNCTION_PREFIX)) return CONJUNCTION_PREFIX;
    return BROADCASTER;
  }
}
