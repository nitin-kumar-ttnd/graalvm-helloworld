// HelloWorld.java - Startup Time Demo
public class HelloWorld {
    public static void main(String[] args) {
        // Print immediately to measure startup time
        System.out.println("Hello, GraalVM World!");
        System.out.println("Application started successfully!");
        
        // Simple computation to show the program is working
        int result = 42 + 8;
        System.out.println("Simple calculation: 42 + 8 = " + result);
        
        // Show some system info
        System.out.println("Java version: " + System.getProperty("java.version"));
        System.out.println("OS: " + System.getProperty("os.name"));
        
        // Exit quickly to focus on startup time
        System.out.println("Goodbye!");
    }
}
