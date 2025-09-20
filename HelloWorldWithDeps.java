// HelloWorldWithDeps.java - Startup demo with more dependencies
import java.util.*;
import java.time.*;

public class HelloWorldWithDeps {
    public static void main(String[] args) {
        System.out.println("Hello, GraalVM World!");
        
        // Use some standard library classes to show dependency loading
        List<String> list = new ArrayList<>();
        list.add("Hello");
        list.add("World");
        
        LocalDateTime now = LocalDateTime.now();
        System.out.println("Current time: " + now);
        System.out.println("List contents: " + list);
        
        // Show reflection usage
        try {
            Class<?> clazz = Class.forName("java.lang.String");
            System.out.println("String class loaded: " + clazz.getName());
        } catch (ClassNotFoundException e) {
            System.out.println("Error loading String class");
        }
        
        System.out.println("Application completed!");
    }
}
