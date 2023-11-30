import java.nio.file.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws Exception {
        Path filePath = Paths.get(args[0]);
        List<String> lines = Files.readAllLines(filePath);
        System.out.println("Received " + lines.size() + " lines of input for part " + args[1]);
    }
}
