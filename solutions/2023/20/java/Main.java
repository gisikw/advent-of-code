import java.nio.file.*;
import java.util.*;
import java.math.*;

class Signal {
  String from;
  String to;
  boolean high;

  public Signal(String from, String to, boolean high) {
    this.from = from;
    this.to = to;
    this.high = high;
  }

  public String from() { return from; }
  public String to() { return to; }
  public boolean high() { return high; }
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

  void processSignal(Signal s, Queue q) {}

  void registerOutput(String m) {
    outputs.add(m);
  }

  void registerInput(String m) {
    inputs.add(m);
  }
}

class BroadcasterModule extends Module {
  public BroadcasterModule(String name) { super(name); }
  void processSignal(Signal s, Queue q) {
    for (String output : outputs) {
      q.add(new Signal(name, output, s.high()));
    }
  }
}

class FlipFlopModule extends Module {
  boolean state = false;
  public FlipFlopModule(String name) { super(name); }
  void processSignal(Signal s, Queue q) {
    if (s.high()) return; 
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
  void processSignal(Signal s, Queue q) {
    state.put(s.from(), s.high());
    boolean allHigh = true;
    for (String input : this.inputs) {
      allHigh = allHigh && state.getOrDefault(input, false);
    }
    for (String output : outputs) {
      q.add(new Signal(name, output, !allHigh));
    }
  }
}

class VoidModule extends Module {
  public VoidModule(String name) { super(name); }
}

public class Main {
  static HashMap<String,Module> modules;

  public static void main(String[] args) throws Exception {
    modules = new HashMap<String,Module>();
    Path filePath = Paths.get(args[0]);
    List<String> lines = Files.readAllLines(filePath);

    for (String line : lines) {
      makeOrGet(line.split(" -> ")[0]);
    }

    for (String line : lines) {
      String[] sections = line.split(" -> ");
      Module srcModule = makeOrGet(sections[0]);
      for (String dest : sections[1].split(", ")) {
        Module dstModule = makeOrGet(dest);
        srcModule.registerOutput(dest.replace("%","").replace("&",""));
        dstModule.registerInput(sections[0].replace("%","").replace("&",""));
      }
    }

    LinkedList<Signal> q = new LinkedList<Signal>();

    int lows = 0;
    int highs = 0;

    if (args[1].equals("1")) {
      for (int i = 0; i < 1000; i++) {
        q.add(new Signal("button", "broadcaster", false));
        while (q.peekFirst() != null) {
          Signal s = q.pop();
          if (s.high()) { highs++; } else { lows++; }
          modules.get(s.to()).processSignal(s, q);
        }
      }
      System.out.println(lows * highs);
    } else {
      long i = 1;

      // These are the examples from my input that feed into the aggregator
      long mk = 0; 
      long fp = 0; 
      long xt = 0; 
      long zc = 0; 
      while (mk == 0 || fp == 0 || xt == 0 || zc == 0) {
        q.add(new Signal("button", "broadcaster", false));
        while (q.peekFirst() != null) {
          Signal s = q.pop();
          if(s.to().equals("kl") && s.from().equals("mk") && s.high()) {
            mk = i;
          }
          if(s.to().equals("kl") && s.from().equals("fp") && s.high()) {
            fp = i;
          }
          if(s.to().equals("kl") && s.from().equals("xt") && s.high()) {
            xt = i;
          }
          if(s.to().equals("kl") && s.from().equals("zc") && s.high()) {
            zc = i;
          }
          modules.get(s.to()).processSignal(s, q);
        }
        i++;
      }
      System.out.println(lcm(lcm(lcm(mk,fp),xt),zc));
    }
  }

  // LCM lovingly swiped from the internet
  public static long lcm(long number1, long number2) {
    if (number1 == 0 || number2 == 0) {
        return 0;
    }
    long absNumber1 = Math.abs(number1);
    long absNumber2 = Math.abs(number2);
    long absHigherNumber = Math.max(absNumber1, absNumber2);
    long absLowerNumber = Math.min(absNumber1, absNumber2);
    long lcm = absHigherNumber;
    while (lcm % absLowerNumber != 0) {
        lcm += absHigherNumber;
    }
    return lcm;
  }

  static Module makeOrGet(String name) {
    String cleanName = name.replace("%","").replace("&","");
    if (!modules.containsKey(cleanName)) {
      if (name.equals("broadcaster")) {
        modules.put(name, new BroadcasterModule(cleanName));
      } else if (name.startsWith("%")) {
        modules.put(cleanName, new FlipFlopModule(cleanName));
      } else if (name.startsWith("&")) {
        modules.put(cleanName, new ConjunctionModule(cleanName));
      } else {
        modules.put(cleanName, new VoidModule(cleanName));
      }
    }
    return modules.get(cleanName);
  }
}
