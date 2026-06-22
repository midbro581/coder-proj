-- ============================================================
-- CODER — more_lessons_v4b.sql
-- Java lessons 11-20 | TypeScript 6-10 | React 6-10 | Git 6-10
-- Import AFTER v2, v3, and v4a
-- ============================================================

USE coder_db;

-- ═══════════════════════════════════════════════════════════
--  JAVA — lessons 11 to 20  (course_id = 2)
-- ═══════════════════════════════════════════════════════════

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(2, 'ArrayList and Generics — Dynamic Collections',
'Java arrays have a fixed size set at creation time. ArrayList is a resizable array — it grows automatically as you add items. It is part of the Java Collections Framework and lives in java.util. Unlike arrays, ArrayLists can only hold objects, not primitives — so you use Integer instead of int, Double instead of double.

Generics let you tell the compiler what type an ArrayList will hold. ArrayList<String> can only contain Strings — the compiler will catch any attempt to add a different type at compile time, not at runtime. Before generics, you needed to cast every element back to its type when reading, which was error-prone. Generics make collections type-safe.

The ArrayList API is rich: add(), remove(), get(), set(), size(), contains(), indexOf(), clear(), sort(). You loop over an ArrayList the same way as an array — with a for loop or an enhanced for-each loop.',
'// ArrayList and Generics in Java
// ─────────────────────────────────────
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Main {
    public static void main(String[] args) {

        // ── Create and populate an ArrayList ──────
        ArrayList<String> languages = new ArrayList<>();   // type-safe list of Strings

        languages.add("Python");
        languages.add("Java");
        languages.add("JavaScript");
        languages.add("C++");

        System.out.println("Size:    " + languages.size());      // 4
        System.out.println("First:   " + languages.get(0));      // Python
        System.out.println("Has SQL: " + languages.contains("SQL")); // false


        // ── Modify ────────────────────────────────
        languages.set(0, "Python 3");       // replace index 0
        languages.remove("C++");            // remove by value
        languages.remove(1);               // remove by index
        System.out.println(languages);     // [Python 3, JavaScript]


        // ── Loop over an ArrayList ────────────────
        ArrayList<Integer> scores = new ArrayList<>();
        scores.add(85); scores.add(92); scores.add(78); scores.add(95);

        int total = 0;
        for (int score : scores) {          // enhanced for-each
            total += score;
        }
        System.out.println("Average: " + (total / (double) scores.size()));


        // ── Sort ──────────────────────────────────
        Collections.sort(scores);
        System.out.println("Sorted: " + scores);         // [78, 85, 92, 95]
        Collections.reverse(scores);
        System.out.println("Reversed: " + scores);       // [95, 92, 85, 78]
        System.out.println("Max: " + Collections.max(scores));   // 95


        // ── Generic method ────────────────────────
        System.out.println("Languages: " + printList(languages));
        System.out.println("Scores:    " + printList(scores));


        // ── Convert array to ArrayList ────────────
        String[] arr = {"HTML", "CSS", "SQL"};
        ArrayList<String> fromArray = new ArrayList<>(List.of(arr));
        System.out.println(fromArray);
    }

    // Generic method — works with any type T
    static <T> String printList(ArrayList<T> list) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            sb.append(list.get(i));
            if (i < list.size() - 1) sb.append(", ");
        }
        sb.append("]");
        return sb.toString();
    }
}',
'java', 11, 20),


(2, 'HashMap — Fast Key-Value Lookups',
'HashMap stores data as key-value pairs — given a key, you get its value in O(1) constant time regardless of how many entries it has. This is because HashMap uses a hash function to compute where to store each entry directly, rather than searching through all entries linearly.

HashMap is unordered — it does not preserve insertion order. If you need insertion order, use LinkedHashMap. If you need sorted keys, use TreeMap. For most use cases where you just need fast lookups by a unique key, HashMap is the right choice.

Common operations: put() adds or updates a key, get() retrieves by key, getOrDefault() returns a fallback if the key is missing (safer than get() which returns null), containsKey() checks existence, remove() deletes, entrySet() lets you loop over all key-value pairs.',
'// HashMap in Java
// ─────────────────────────────────────
import java.util.HashMap;
import java.util.Map;

public class Main {
    public static void main(String[] args) {

        // ── Basic HashMap ──────────────────────────
        HashMap<String, Integer> scores = new HashMap<>();

        scores.put("Ahmed",  92);
        scores.put("Sara",   85);
        scores.put("Omar",   78);
        scores.put("Fatima", 95);

        System.out.println(scores.get("Ahmed"));                   // 92
        System.out.println(scores.get("Unknown"));                 // null
        System.out.println(scores.getOrDefault("Unknown", 0));    // 0 — safe!
        System.out.println(scores.containsKey("Sara"));           // true
        System.out.println(scores.size());                         // 4


        // ── Update and delete ─────────────────────
        scores.put("Ahmed", 95);          // overwrite — put updates if key exists
        scores.remove("Omar");
        System.out.println(scores);       // {Ahmed=95, Sara=85, Fatima=95}


        // ── Loop over all entries ──────────────────
        for (Map.Entry<String, Integer> entry : scores.entrySet()) {
            System.out.printf("%-10s → %d%n", entry.getKey(), entry.getValue());
        }


        // ── Word frequency counter ─────────────────
        String text = "the cat sat on the mat the cat";
        HashMap<String, Integer> freq = new HashMap<>();

        for (String word : text.split(" ")) {
            freq.put(word, freq.getOrDefault(word, 0) + 1);
        }
        System.out.println(freq);
        // {the=3, cat=2, sat=1, on=1, mat=1}


        // ── HashMap as a cache / lookup table ─────
        HashMap<Integer, String> courseNames = new HashMap<>();
        courseNames.put(1, "Python");
        courseNames.put(2, "Java");
        courseNames.put(3, "JavaScript");

        int courseId = 2;
        System.out.println("Course: " + courseNames.getOrDefault(courseId, "Unknown"));


        // ── Nested HashMap (like JSON objects) ────
        HashMap<String, HashMap<String, Object>> users = new HashMap<>();

        HashMap<String, Object> ahmed = new HashMap<>();
        ahmed.put("xp",    1500);
        ahmed.put("level", 16);
        users.put("ahmed", ahmed);

        System.out.println(users.get("ahmed").get("xp"));   // 1500
    }
}',
'java', 12, 20),


(2, 'Exception Handling — Robust Java Programs',
'Java has a rich exception hierarchy. Exceptions fall into two categories: checked exceptions (the compiler forces you to handle them — like IOException, SQLException) and unchecked exceptions (they extend RuntimeException — like NullPointerException, ArrayIndexOutOfBoundsException). Checked exceptions represent recoverable situations; unchecked ones usually represent programming errors.

The try-catch-finally structure mirrors Python and JavaScript. Multi-catch (catching multiple exception types in one catch block with |) was added in Java 7 to reduce duplication. The throws keyword in a method signature declares that the method may throw a checked exception — callers must handle it.

Creating custom exceptions by extending Exception (checked) or RuntimeException (unchecked) lets you communicate domain-specific errors clearly. A properly designed exception carries enough information to diagnose and recover from the problem.',
'// Exception Handling in Java
// ─────────────────────────────────────
import java.io.*;

public class Main {

    // ── Checked exception — caller MUST handle ────
    static String readFile(String path) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(path))) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line).append("\n");
            }
        }
        return sb.toString();
    }


    // ── Custom exceptions ─────────────────────────
    static class InsufficientFundsException extends Exception {
        private final double amount;
        private final double balance;

        InsufficientFundsException(double amount, double balance) {
            super(String.format("Cannot withdraw $%.2f. Balance is $%.2f.", amount, balance));
            this.amount  = amount;
            this.balance = balance;
        }
        double getAmount()  { return amount; }
        double getBalance() { return balance; }
    }

    static class BankAccount {
        private double balance;
        BankAccount(double balance) { this.balance = balance; }

        void withdraw(double amount) throws InsufficientFundsException {
            if (amount > balance) throw new InsufficientFundsException(amount, balance);
            balance -= amount;
        }
        double getBalance() { return balance; }
    }


    public static void main(String[] args) {

        // ── Basic try-catch-finally ────────────────
        try {
            int result = 10 / 0;           // ArithmeticException
        } catch (ArithmeticException e) {
            System.out.println("Math error: " + e.getMessage());
        } finally {
            System.out.println("Always runs");
        }


        // ── Multi-catch ───────────────────────────
        String[] arr = {"hello", "world"};
        try {
            System.out.println(arr[5]);              // ArrayIndexOutOfBoundsException
            int n = Integer.parseInt("not-a-number"); // NumberFormatException
        } catch (ArrayIndexOutOfBoundsException | NumberFormatException e) {
            System.out.println("Caught: " + e.getClass().getSimpleName());
        }


        // ── Custom exception ──────────────────────
        BankAccount account = new BankAccount(100.0);
        try {
            account.withdraw(150.0);
        } catch (InsufficientFundsException e) {
            System.out.println(e.getMessage());
            System.out.printf("You need $%.2f more.%n",
                              e.getAmount() - e.getBalance());
        }


        // ── Checked exception: file not found ─────
        try {
            String content = readFile("data.txt");
            System.out.println(content);
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + e.getMessage());
        } catch (IOException e) {
            System.out.println("IO error: " + e.getMessage());
        }
    }
}',
'java', 13, 20),


(2, 'Interfaces — Defining Contracts in Java',
'An interface in Java is a pure contract — it defines WHAT a class must do but not HOW. A class that implements an interface must provide implementations for all the interface''s methods. Interfaces enable polymorphism: you can write code against the interface type and it will work with any class that implements it.

Interfaces solve a limitation of single inheritance — Java classes can extend only one parent class, but they can implement multiple interfaces. This is how Java achieves the flexibility of multiple inheritance without its complications.

Since Java 8, interfaces can have default methods (with a body) and static methods. Default methods let you add new methods to an interface without breaking all existing implementations — an important feature for evolving APIs.',
'// Interfaces in Java
// ─────────────────────────────────────

public class Main {

    // ── Define interfaces ─────────────────────────
    interface Drawable {
        void draw();                        // abstract method — no body
        default String getType() {          // default method — has body
            return "Unknown shape";
        }
    }

    interface Resizable {
        void resize(double factor);
        double getArea();
    }


    // ── Implement multiple interfaces ─────────────
    static class Circle implements Drawable, Resizable {
        private double radius;

        Circle(double radius) { this.radius = radius; }

        @Override
        public void draw() {
            System.out.printf("Drawing circle with radius %.1f%n", radius);
        }

        @Override
        public String getType() { return "Circle"; }    // overrides default

        @Override
        public void resize(double factor) { radius *= factor; }

        @Override
        public double getArea() { return Math.PI * radius * radius; }
    }

    static class Rectangle implements Drawable, Resizable {
        private double width, height;

        Rectangle(double w, double h) { width = w; height = h; }

        @Override
        public void draw() {
            System.out.printf("Drawing rectangle %.1f × %.1f%n", width, height);
        }

        @Override
        public void resize(double factor) { width *= factor; height *= factor; }

        @Override
        public double getArea() { return width * height; }
    }


    // ── Comparable — a standard Java interface ────
    static class Student implements Comparable<Student> {
        String name;
        double gpa;

        Student(String name, double gpa) { this.name = name; this.gpa = gpa; }

        @Override
        public int compareTo(Student other) {
            return Double.compare(other.gpa, this.gpa);   // descending by GPA
        }

        @Override
        public String toString() { return name + " (" + gpa + ")"; }
    }


    public static void main(String[] args) {

        // ── Polymorphism via interface ─────────────
        Drawable[] shapes = { new Circle(5), new Rectangle(4, 6) };
        for (Drawable shape : shapes) {
            shape.draw();
            System.out.println("Type: " + shape.getType());
        }

        // Resize using the Resizable interface
        Resizable[] resizable = { new Circle(5), new Rectangle(4, 6) };
        for (Resizable r : resizable) {
            System.out.printf("Before: %.2f → ", r.getArea());
            r.resize(2.0);
            System.out.printf("After: %.2f%n", r.getArea());
        }

        // ── Sorting with Comparable ────────────────
        java.util.ArrayList<Student> students = new java.util.ArrayList<>();
        students.add(new Student("Ahmed",  3.9));
        students.add(new Student("Sara",   3.7));
        students.add(new Student("Fatima", 4.0));
        java.util.Collections.sort(students);
        students.forEach(System.out::println);
        // Fatima (4.0), Ahmed (3.9), Sara (3.7)
    }
}',
'java', 14, 20),


(2, 'Lambda Expressions and the Stream API',
'Lambda expressions, introduced in Java 8, let you write anonymous functions inline. Instead of creating a whole anonymous class to implement a single-method interface, you write (parameters) -> expression. This makes code much shorter and more readable, especially when working with collections.

The Streams API is a powerful toolkit for processing sequences of data in a functional style. A stream is a pipeline of operations: source → intermediate operations (filter, map, sorted) → terminal operation (collect, reduce, forEach, count). Stream operations are lazy — intermediate operations do not run until a terminal operation triggers them.

Together, lambdas and streams replace most for loops and temporary lists in modern Java code. The syntax takes some getting used to but the result is expressive, concise, and easy to parallelise.',
'// Lambdas and Streams in Java 8+
// ─────────────────────────────────────
import java.util.*;
import java.util.stream.*;

public class Main {
    public static void main(String[] args) {

        // ── Lambda basics ─────────────────────────
        // Old way: anonymous class
        Runnable oldWay = new Runnable() {
            @Override public void run() { System.out.println("Running!"); }
        };

        // New way: lambda
        Runnable newWay = () -> System.out.println("Running!");
        newWay.run();

        // Comparator with lambda
        List<String> names = new ArrayList<>(Arrays.asList("Charlie", "Alice", "Bob"));
        names.sort((a, b) -> a.compareTo(b));          // sort alphabetically
        System.out.println(names);                      // [Alice, Bob, Charlie]

        names.sort((a, b) -> b.length() - a.length()); // sort by length descending
        System.out.println(names);                      // [Charlie, Alice, Bob]


        // ── Stream pipeline ───────────────────────
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

        // filter → map → collect
        List<Integer> evenSquares = numbers.stream()
            .filter(n -> n % 2 == 0)          // keep evens: [2,4,6,8,10]
            .map(n -> n * n)                   // square each: [4,16,36,64,100]
            .collect(Collectors.toList());
        System.out.println(evenSquares);       // [4, 16, 36, 64, 100]

        // sum with reduce
        int sum = numbers.stream()
            .reduce(0, Integer::sum);          // method reference — same as (a,b) -> a+b
        System.out.println("Sum: " + sum);     // 55

        // count, min, max
        System.out.println("Count: " + numbers.stream().count());           // 10
        System.out.println("Max:   " + numbers.stream().mapToInt(Integer::intValue).max().getAsInt()); // 10


        // ── Working with objects ───────────────────
        record Student(String name, double gpa, String major) {}

        List<Student> students = Arrays.asList(
            new Student("Ahmed",  3.9, "CS"),
            new Student("Sara",   3.7, "Math"),
            new Student("Fatima", 4.0, "CS"),
            new Student("Omar",   3.2, "Art")
        );

        // CS students sorted by GPA desc
        List<String> csTopStudents = students.stream()
            .filter(s -> s.major().equals("CS"))
            .sorted((a, b) -> Double.compare(b.gpa(), a.gpa()))
            .map(Student::name)
            .collect(Collectors.toList());
        System.out.println("CS top students: " + csTopStudents); // [Fatima, Ahmed]

        // Average GPA
        OptionalDouble avgGpa = students.stream()
            .mapToDouble(Student::gpa)
            .average();
        System.out.printf("Average GPA: %.2f%n", avgGpa.getAsDouble());   // 3.70

        // Group by major
        Map<String, List<Student>> byMajor = students.stream()
            .collect(Collectors.groupingBy(Student::major));
        byMajor.forEach((major, list) ->
            System.out.println(major + ": " + list.stream().map(Student::name).collect(Collectors.joining(", ")))
        );
    }
}',
'java', 15, 20),


(2, 'File I/O — Reading and Writing in Java',
'Java provides multiple APIs for file operations, from the classic java.io to the modern java.nio.file (NIO). The modern Path and Files API (introduced in Java 7) is simpler and more powerful — prefer it for new code. Files.readString() reads an entire file in one line. Files.writeString() writes a string. Files.readAllLines() gives you a List<String> you can iterate over directly.

For large files, wrap a FileReader in a BufferedReader and read line by line — this avoids loading the entire file into memory at once. For writing large files, wrap a FileWriter in a PrintWriter or BufferedWriter.

Try-with-resources (the try (Resource r = ...) syntax) automatically closes the resource when the block exits, even if an exception occurs. Always use it for file handles, database connections, and network sockets.',
'// File I/O in Java
// ─────────────────────────────────────
import java.io.*;
import java.nio.file.*;
import java.util.List;

public class Main {
    public static void main(String[] args) throws IOException {

        // ── Modern NIO API — simple one-liners ────
        Path file = Path.of("output.txt");

        // Write
        Files.writeString(file, "Hello, World!\nSecond line.\n");
        System.out.println("Written.");

        // Read entire file
        String content = Files.readString(file);
        System.out.print(content);

        // Read as list of lines
        List<String> lines = Files.readAllLines(file);
        System.out.println("Lines: " + lines.size());
        for (String line : lines) {
            System.out.println("  > " + line);
        }

        // Append to file
        Files.writeString(file, "Third line.\n", StandardOpenOption.APPEND);


        // ── Classic BufferedReader for large files ─
        try (BufferedReader reader = new BufferedReader(new FileReader("output.txt"))) {
            String line;
            int lineNum = 1;
            while ((line = reader.readLine()) != null) {
                System.out.println(lineNum++ + ": " + line);
            }
        }
        // File is automatically closed when try block exits


        // ── PrintWriter for formatted output ──────
        try (PrintWriter writer = new PrintWriter(new FileWriter("report.txt"))) {
            writer.println("=== REPORT ===");
            writer.printf("%-15s %5s%n", "Name", "Score");
            writer.printf("%-15s %5d%n", "Ahmed",  92);
            writer.printf("%-15s %5d%n", "Sara",   85);
            writer.printf("%-15s %5d%n", "Fatima", 97);
        }
        System.out.println("Report:");
        System.out.print(Files.readString(Path.of("report.txt")));


        // ── Working with directories ───────────────
        Path dir = Path.of("my_folder");
        if (!Files.exists(dir)) {
            Files.createDirectory(dir);
            System.out.println("Directory created.");
        }

        // Copy and delete
        Files.copy(file, dir.resolve("copy.txt"), StandardCopyOption.REPLACE_EXISTING);
        System.out.println("File copied.");

        // Cleanup
        Files.deleteIfExists(file);
        Files.deleteIfExists(dir.resolve("copy.txt"));
        Files.deleteIfExists(dir);
        Files.deleteIfExists(Path.of("report.txt"));
        System.out.println("Cleaned up.");
    }
}',
'java', 16, 20),


(2, 'Enums and Records — Modern Java Data Types',
'An enum (enumeration) is a type with a fixed set of named constants. Enums are much better than using raw int or String constants because they are type-safe — you cannot accidentally pass an invalid value. Java enums are full classes: they can have fields, constructors, and methods.

Records, added in Java 16, are immutable data carriers — a way to create a simple class that holds data with minimal boilerplate. A record automatically gets a constructor, getters (named after the fields, not getXxx), equals(), hashCode(), and toString(). Use records for data transfer objects, coordinates, API response models — anything that is just a container for values.',
'// Enums and Records in Java
// ─────────────────────────────────────

public class Main {

    // ── Basic enum ────────────────────────────────
    enum Day { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

    enum Level {
        BEGINNER("Just starting out"),
        INTERMEDIATE("Good grasp of basics"),
        ADVANCED("Ready for complex topics");

        private final String description;

        Level(String description) {        // enum constructor
            this.description = description;
        }

        public String getDescription() { return description; }

        public boolean isAdvanced() { return this == ADVANCED; }
    }


    // ── Records — immutable data classes ──────────
    record Point(double x, double y) {
        // You can add methods to records
        double distanceTo(Point other) {
            double dx = this.x - other.x;
            double dy = this.y - other.y;
            return Math.sqrt(dx * dx + dy * dy);
        }

        // Compact constructor — add validation
        Point {
            if (Double.isNaN(x) || Double.isNaN(y)) {
                throw new IllegalArgumentException("Coordinates cannot be NaN");
            }
        }
    }

    record Student(int id, String name, double gpa, Level level) {}


    public static void main(String[] args) {

        // ── Enum usage ────────────────────────────
        Day today = Day.WEDNESDAY;
        System.out.println("Day: " + today);          // WEDNESDAY
        System.out.println("Ordinal: " + today.ordinal());  // 2 (zero-based)
        System.out.println("Name: " + today.name());  // WEDNESDAY

        Level myLevel = Level.INTERMEDIATE;
        System.out.println(myLevel.getDescription()); // Good grasp of basics
        System.out.println(myLevel.isAdvanced());     // false


        // ── Switch with enum ──────────────────────
        String message = switch (today) {
            case MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY -> "Weekday — study time!";
            case SATURDAY, SUNDAY -> "Weekend — rest up!";
        };
        System.out.println(message);


        // ── Records usage ─────────────────────────
        Point a = new Point(0, 0);
        Point b = new Point(3, 4);

        System.out.println("Point a: " + a);                        // Point[x=0.0, y=0.0]
        System.out.println("Distance: " + a.distanceTo(b));         // 5.0
        System.out.println("a.x() = " + a.x());                    // 0.0 — getter is x(), not getX()

        // Records are immutable — no setters
        // a.x = 10;  // compile error

        // Records get equals/hashCode automatically
        Point c = new Point(0, 0);
        System.out.println("a.equals(c): " + a.equals(c));  // true


        // ── Record for student data ────────────────
        Student ahmed = new Student(1, "Ahmed", 3.9, Level.ADVANCED);
        System.out.println(ahmed);                     // Student[id=1, name=Ahmed, ...]
        System.out.println("GPA: " + ahmed.gpa());
        System.out.println("Advanced? " + ahmed.level().isAdvanced()); // true
    }
}',
'java', 17, 20),


(2, 'Multithreading Basics — Doing Things in Parallel',
'A thread is an independent flow of execution. By default your Java program runs on one thread — the main thread. Multithreading lets you run multiple tasks simultaneously: download a file while keeping the UI responsive, process multiple requests at the same time, or split a large computation across CPU cores.

Java provides several ways to create threads. The classic approach: extend Thread or implement Runnable. The modern approach: use an ExecutorService from java.util.concurrent which manages a pool of threads for you — you just submit tasks. Thread pools are far better than creating raw threads, which are expensive.

Thread safety is the hard part. When multiple threads share data, they can interfere with each other in subtle ways. The synchronized keyword, atomic variables, and concurrent collections from java.util.concurrent are the main tools for keeping shared data safe.',
'// Multithreading in Java
// ─────────────────────────────────────
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

public class Main {

    // ── Way 1: Implement Runnable ──────────────────
    static class Task implements Runnable {
        private final String name;
        Task(String name) { this.name = name; }

        @Override
        public void run() {
            for (int i = 1; i <= 3; i++) {
                System.out.println(name + ": step " + i);
                try { Thread.sleep(100); } catch (InterruptedException e) { break; }
            }
        }
    }


    public static void main(String[] args) throws InterruptedException, ExecutionException {

        // ── Raw threads ────────────────────────────
        Thread t1 = new Thread(new Task("Worker-1"));
        Thread t2 = new Thread(new Task("Worker-2"));

        t1.start();   // starts a new thread
        t2.start();   // both threads run concurrently
        t1.join();    // wait for t1 to finish
        t2.join();    // wait for t2 to finish
        // Output order is non-deterministic — threads interleave


        // ── Lambda thread (modern) ─────────────────
        Thread lambda = new Thread(() -> System.out.println("Lambda thread!"));
        lambda.start();
        lambda.join();


        // ── ExecutorService — preferred approach ───
        ExecutorService pool = Executors.newFixedThreadPool(3);  // 3 worker threads

        for (int i = 1; i <= 5; i++) {
            final int taskId = i;
            pool.submit(() -> {
                System.out.println("Task " + taskId + " on " + Thread.currentThread().getName());
                return taskId * 2;   // Callable returns a result
            });
        }
        pool.shutdown();              // stop accepting new tasks
        pool.awaitTermination(5, TimeUnit.SECONDS);


        // ── Future — get result from a thread ──────
        ExecutorService exec = Executors.newSingleThreadExecutor();
        Future<Integer> future = exec.submit(() -> {
            Thread.sleep(200);   // simulate work
            return 42;
        });

        System.out.println("Doing other work while task runs...");
        int result = future.get();   // blocks until the result is ready
        System.out.println("Result: " + result);   // 42
        exec.shutdown();


        // ── Thread safety: AtomicInteger ──────────
        AtomicInteger counter = new AtomicInteger(0);
        ExecutorService workers = Executors.newFixedThreadPool(10);

        for (int i = 0; i < 1000; i++) {
            workers.submit(() -> counter.incrementAndGet());   // thread-safe increment
        }
        workers.shutdown();
        workers.awaitTermination(5, TimeUnit.SECONDS);
        System.out.println("Counter: " + counter.get());  // always 1000 — thread-safe!
    }
}',
'java', 18, 20),


(2, 'Java Design Patterns — Writing Professional Code',
'Design patterns are proven solutions to common programming problems. They are not code you copy — they are templates for how to structure your code to be flexible, reusable, and maintainable. Learning them teaches you the vocabulary used by professional Java developers everywhere.

The Singleton pattern ensures a class has exactly one instance, which is useful for shared resources like a database connection or configuration object. The Builder pattern constructs complex objects step by step, replacing constructors with too many parameters. The Observer pattern lets objects subscribe to and receive notifications about events.',
'// Java Design Patterns
// ─────────────────────────────────────

// ── Singleton — exactly one instance ──────────────
class DatabaseConnection {
    // volatile ensures the instance is visible to all threads immediately
    private static volatile DatabaseConnection instance;
    private String url;

    private DatabaseConnection() {   // private constructor prevents new DatabaseConnection()
        this.url = "jdbc:mysql://localhost/coder_db";
        System.out.println("Connection created.");
    }

    public static DatabaseConnection getInstance() {
        if (instance == null) {
            synchronized (DatabaseConnection.class) {   // thread-safe
                if (instance == null) {
                    instance = new DatabaseConnection();
                }
            }
        }
        return instance;
    }

    public String getUrl() { return url; }
}


// ── Builder — construct complex objects step by step ──
class User {
    private final String username;
    private final String email;
    private final int    xp;
    private final String role;
    private final boolean active;

    private User(Builder b) {
        this.username = b.username;
        this.email    = b.email;
        this.xp       = b.xp;
        this.role     = b.role;
        this.active   = b.active;
    }

    @Override public String toString() {
        return String.format("User{%s, %s, xp=%d, role=%s, active=%b}", username, email, xp, role, active);
    }

    static class Builder {
        private final String username;  // required
        private final String email;     // required
        private int     xp     = 0;        // optional with defaults
        private String  role   = "student";
        private boolean active = true;

        Builder(String username, String email) {
            this.username = username;
            this.email    = email;
        }

        Builder xp(int xp)         { this.xp    = xp;   return this; }
        Builder role(String role)   { this.role  = role; return this; }
        Builder inactive()          { this.active = false; return this; }
        User build()                { return new User(this); }
    }
}


// ── Observer — event subscription ─────────────────
interface LessonObserver {
    void onLessonCompleted(String studentName, int xpEarned);
}

class LessonService {
    private java.util.List<LessonObserver> observers = new java.util.ArrayList<>();

    void subscribe(LessonObserver obs)   { observers.add(obs); }
    void unsubscribe(LessonObserver obs) { observers.remove(obs); }

    void completeLesson(String student, int xp) {
        System.out.println(student + " completed a lesson!");
        for (LessonObserver obs : observers) {
            obs.onLessonCompleted(student, xp);
        }
    }
}


public class Main {
    public static void main(String[] args) {
        // Singleton
        DatabaseConnection db1 = DatabaseConnection.getInstance();
        DatabaseConnection db2 = DatabaseConnection.getInstance();
        System.out.println("Same instance: " + (db1 == db2));   // true

        // Builder
        User ahmed = new User.Builder("ahmed", "ahmed@email.com")
                              .xp(1500)
                              .role("admin")
                              .build();
        System.out.println(ahmed);

        // Observer
        LessonService service = new LessonService();
        service.subscribe((name, xp) -> System.out.println("Email sent to " + name + " (+"+xp+" XP)"));
        service.subscribe((name, xp) -> System.out.println("Leaderboard updated for " + name));
        service.completeLesson("Ahmed", 15);
    }
}',
'java', 19, 20),


(2, 'Build a Real Project — Library Management System',
'This project brings together everything from the Java course: classes, inheritance, interfaces, generics, ArrayList, HashMap, exceptions, file I/O, and design patterns. A Library Management System is a classic exercise that mirrors real business software — tracking resources, users, and transactions.',
'// Library Management System — Full Java Project
// ─────────────────────────────────────────────
import java.util.*;
import java.time.LocalDate;

// ── Domain model ──────────────────────────────────
record Book(String isbn, String title, String author, int year) {
    @Override public String toString() {
        return String.format("\"%s\" by %s (%d) [%s]", title, author, year, isbn);
    }
}

class Library {
    private final Map<String, Book>   catalog    = new HashMap<>();
    private final Map<String, String> checkedOut = new HashMap<>();  // isbn → borrower

    void addBook(Book book) {
        catalog.put(book.isbn(), book);
        System.out.println("Added: " + book.title());
    }

    void checkout(String isbn, String borrower) throws Exception {
        if (!catalog.containsKey(isbn))
            throw new Exception("Book not found: " + isbn);
        if (checkedOut.containsKey(isbn))
            throw new Exception("Already checked out by: " + checkedOut.get(isbn));

        checkedOut.put(isbn, borrower);
        System.out.printf("'%s' checked out to %s%n", catalog.get(isbn).title(), borrower);
    }

    void returnBook(String isbn) throws Exception {
        if (!checkedOut.containsKey(isbn))
            throw new Exception("This book is not checked out: " + isbn);

        String borrower = checkedOut.remove(isbn);
        System.out.printf("'%s' returned by %s%n", catalog.get(isbn).title(), borrower);
    }

    List<Book> search(String query) {
        String q = query.toLowerCase();
        return catalog.values().stream()
            .filter(b -> b.title().toLowerCase().contains(q)
                      || b.author().toLowerCase().contains(q))
            .sorted(Comparator.comparing(Book::title))
            .toList();
    }

    void printStatus() {
        System.out.println("\n=== Library Status ===");
        System.out.println("Total books: " + catalog.size());
        System.out.println("Available:   " + (catalog.size() - checkedOut.size()));
        System.out.println("Checked out: " + checkedOut.size());

        if (!checkedOut.isEmpty()) {
            System.out.println("\nCurrently borrowed:");
            checkedOut.forEach((isbn, borrower) ->
                System.out.printf("  %-30s → %s%n", catalog.get(isbn).title(), borrower)
            );
        }
    }
}

public class Main {
    public static void main(String[] args) {
        Library lib = new Library();

        // Add books
        lib.addBook(new Book("978-0-13-110362-7", "The C Programming Language", "Kernighan & Ritchie", 1978));
        lib.addBook(new Book("978-0-13-468599-1", "Effective Java",              "Joshua Bloch",         2018));
        lib.addBook(new Book("978-0-13-235088-4", "Clean Code",                  "Robert C. Martin",     2008));
        lib.addBook(new Book("978-0-59-651798-6", "JavaScript: The Good Parts",  "Douglas Crockford",    2008));

        // Search
        System.out.println("\nSearch ''java'':");
        lib.search("java").forEach(System.out::println);

        // Checkout and return
        try {
            lib.checkout("978-0-13-468599-1", "Ahmed");
            lib.checkout("978-0-13-235088-4", "Sara");
            lib.checkout("978-0-13-468599-1", "Omar");  // should fail
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }

        lib.printStatus();

        try {
            lib.returnBook("978-0-13-468599-1");
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }

        lib.printStatus();
    }
}',
'java', 20, 20);

-- Update Java lesson count
UPDATE courses SET lessons = 20 WHERE id = 2;


-- ═══════════════════════════════════════════════════════════
--  TYPESCRIPT — lessons 6 to 10
-- ═══════════════════════════════════════════════════════════

SET @ts_id = (SELECT id FROM courses WHERE language = 'typescript' LIMIT 1);

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@ts_id, 'Type Narrowing and Type Guards',
'TypeScript knows the type of a variable at each point in your code — but sometimes it needs your help. Type narrowing is the process of refining a broad type (like string | number | null) to a more specific one inside a conditional block. TypeScript tracks what checks you do and automatically narrows the type after them.

The typeof operator narrows to primitive types. The instanceof operator narrows class instances. In operator checks object properties. Writing your own type guard function — one that returns x is SomeType — lets you narrow to any type you need, including custom interfaces where typeof and instanceof do not help.

Exhaustiveness checking is a powerful pattern: if you use a discriminated union and TypeScript still sees possible cases in a never type, it means you forgot to handle a variant. This catches missing cases at compile time.',
'// TypeScript — Type Narrowing
// ─────────────────────────────────

// ── typeof narrowing ──────────────────────────────
function process(value: string | number | boolean) {
    if (typeof value === "string") {
        return value.toUpperCase();   // TypeScript knows: string
    } else if (typeof value === "number") {
        return value.toFixed(2);      // TypeScript knows: number
    } else {
        return String(value);         // TypeScript knows: boolean
    }
}

console.log(process("hello"));   // HELLO
console.log(process(3.14159));   // 3.14
console.log(process(true));      // true


// ── Nullability narrowing ──────────────────────────
function greet(name: string | null | undefined) {
    if (!name) {
        return "Hello, stranger!";
    }
    return `Hello, ${name}!`;   // TypeScript knows name is string here
}


// ── instanceof narrowing ──────────────────────────
class Dog { bark() { return "Woof!"; } }
class Cat { meow() { return "Meow!"; } }

function makeSound(animal: Dog | Cat) {
    if (animal instanceof Dog) {
        return animal.bark();   // TypeScript knows: Dog
    }
    return animal.meow();       // TypeScript knows: Cat
}


// ── Discriminated unions — the most powerful pattern ─
type Shape =
    | { kind: "circle";    radius: number }
    | { kind: "rectangle"; width: number; height: number }
    | { kind: "triangle";  base: number; height: number };

function area(shape: Shape): number {
    switch (shape.kind) {
        case "circle":    return Math.PI * shape.radius ** 2;
        case "rectangle": return shape.width * shape.height;
        case "triangle":  return 0.5 * shape.base * shape.height;
        default:
            // If you add a new variant to Shape and forget to handle it,
            // TypeScript flags this line as an error:
            const _exhaustive: never = shape;
            throw new Error("Unhandled shape: " + _exhaustive);
    }
}

console.log(area({ kind: "circle",    radius: 5 }).toFixed(2));       // 78.54
console.log(area({ kind: "rectangle", width: 4, height: 6 }));        // 24
console.log(area({ kind: "triangle",  base: 3, height: 8 }));         // 12


// ── Custom type guard ─────────────────────────────
interface User  { username: string; xp: number; }
interface Admin extends User { permissions: string[]; }

// The return type "x is Admin" is the type guard
function isAdmin(user: User | Admin): user is Admin {
    return "permissions" in user;
}

function handleUser(user: User | Admin) {
    if (isAdmin(user)) {
        console.log("Admin with permissions:", user.permissions);  // safe
    } else {
        console.log("Regular user:", user.username);               // safe
    }
}',
'typescript', 6, 20),


(@ts_id, 'Utility Types — TypeScript''s Built-in Toolkit',
'TypeScript ships with a set of utility types that transform existing types into new ones. Instead of manually writing every variation of an interface, utility types let you derive them. These are used constantly in real TypeScript projects and in every major library''s type definitions.

The most important ones: Partial<T> makes all properties optional (useful for update payloads), Required<T> makes all properties required, Readonly<T> prevents modification, Pick<T, K> extracts specific keys, Omit<T, K> removes specific keys, Record<K, V> creates a key-value map type, ReturnType<F> extracts a function''s return type.',
'// TypeScript — Utility Types
// ─────────────────────────────────

interface User {
    id:       number;
    username: string;
    email:    string;
    xp:       number;
    role:     "student" | "admin";
    bio?:     string;   // already optional
}


// ── Partial — all fields optional (great for updates) ──
type UserUpdate = Partial<User>;

function updateUser(id: number, changes: UserUpdate): void {
    // changes can have ANY subset of User fields
    console.log(`Updating user ${id}:`, changes);
}
updateUser(1, { xp: 1500 });            // only update xp
updateUser(2, { email: "new@email.com", bio: "Hello!" });


// ── Required — remove all optionals ──────────────
type CompleteUser = Required<User>;
// Now bio is required — compiler will enforce it


// ── Readonly — prevent mutation ───────────────────
type ImmutableUser = Readonly<User>;
const frozenUser: ImmutableUser = {
    id: 1, username: "ahmed", email: "a@a.com", xp: 0, role: "student"
};
// frozenUser.xp = 100;   // ERROR: Cannot assign to ''xp'' because it is read-only


// ── Pick — extract specific fields ────────────────
type UserPreview = Pick<User, "id" | "username" | "xp">;
// { id: number; username: string; xp: number }

function renderCard(user: UserPreview) {
    console.log(`${user.username} — ${user.xp} XP`);
}


// ── Omit — remove specific fields ─────────────────
type PublicUser = Omit<User, "email" | "role">;
// Safe to send to the browser — no sensitive fields


// ── Record — typed key-value map ───────────────────
type Language = "python" | "javascript" | "java" | "cpp";

const languageIcons: Record<Language, string> = {
    python:     "fab fa-python",
    javascript: "fab fa-js-square",
    java:       "fab fa-java",
    cpp:        "fas fa-code",
};
// Adding a new Language without adding to this object → compile error!


// ── ReturnType — extract function return type ──────
function createUser(name: string, email: string) {
    return { id: Math.random(), name, email, createdAt: new Date() };
}
type NewUser = ReturnType<typeof createUser>;
// { id: number; name: string; email: string; createdAt: Date }


// ── Combining utility types in practice ───────────
type CreateUserDTO = Omit<User, "id">;          // no id when creating
type UpdateUserDTO = Partial<Omit<User, "id">>; // optional fields, no id
type UserResponse  = Readonly<PublicUser>;       // read-only public view

const dto: CreateUserDTO = {
    username: "sara", email: "sara@email.com", xp: 0, role: "student"
};
console.log(dto);',
'typescript', 7, 20),


(@ts_id, 'Async TypeScript — Typed Promises and Fetch',
'TypeScript''s type system works seamlessly with async/await and Promises. You can annotate the return type of an async function as Promise<T>, where T is the type of the resolved value. This means callers know exactly what they will get when they await the function.

Typing API responses is one of the most valuable uses of TypeScript. Define an interface for your API response shape, then use it as the generic parameter for fetch''s response parsing. If the API changes and the type no longer matches, TypeScript will catch the mismatch in your consuming code.',
'// Async TypeScript — Typed API Calls
// ─────────────────────────────────────

// ── Define your data shapes ───────────────────────
interface Course {
    id:       number;
    title:    string;
    language: string;
    level:    "Beginner" | "Intermediate" | "Advanced";
    lessons:  number;
}

interface Lesson {
    id:          number;
    course_id:   number;
    title:       string;
    content:     string;
    xp_reward:   number;
    order_num:   number;
}

interface ApiResponse<T> {
    data:    T;
    status:  number;
    message: string;
}


// ── Typed fetch wrapper ───────────────────────────
async function apiFetch<T>(url: string): Promise<T> {
    const response = await fetch(url);
    if (!response.ok) {
        throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    return response.json() as Promise<T>;
}


// ── Functions with typed return values ───────────
async function getCourses(): Promise<Course[]> {
    return apiFetch<Course[]>("/api/courses");
}

async function getLesson(id: number): Promise<Lesson> {
    return apiFetch<Lesson>(`/api/lessons/single/${id}`);
}


// ── Error handling with typed errors ─────────────
class ApiError extends Error {
    constructor(
        message: string,
        public readonly statusCode: number
    ) {
        super(message);
        this.name = "ApiError";
    }
}

async function safeFetch<T>(url: string): Promise<T | null> {
    try {
        const res = await fetch(url);
        if (res.status === 404) return null;
        if (!res.ok) throw new ApiError(res.statusText, res.status);
        return res.json() as Promise<T>;
    } catch (err) {
        if (err instanceof ApiError) {
            console.error(`API Error ${err.statusCode}: ${err.message}`);
        } else {
            console.error("Network error:", err);
        }
        return null;
    }
}


// ── Using it all together ─────────────────────────
async function loadDashboard(userId: number): Promise<void> {
    const [courses, progress] = await Promise.all([
        getCourses(),
        safeFetch<number[]>(`/api/progress/${userId}`),
    ]);

    if (!progress) {
        console.log("No progress data available");
        return;
    }

    const completedCount = progress.length;
    console.log(`${courses.length} courses, ${completedCount} lessons done`);

    const started = courses.filter(c =>
        // TypeScript knows c.id is number, progress is number[] — no type casting
        progress.some(lessonId => lessonId > 0)
    );
    console.log(`${started.length} courses started`);
}',
'typescript', 8, 20),


(@ts_id, 'TypeScript with Express — Type-Safe Backend',
'TypeScript is not just for the browser — it is widely used for Node.js backends, and it makes Express APIs significantly safer and more maintainable. You can type request bodies, query parameters, URL params, and response shapes, catching mismatches before they cause runtime errors in production.

The @types packages provide TypeScript type definitions for libraries that were written in plain JavaScript. When you install @types/express, TypeScript knows the types of req, res, next, and all their properties. Most popular npm packages either include types natively or have a corresponding @types package.',
'// TypeScript with Express — Type-Safe API
// ─────────────────────────────────────────
// Install: npm install express && npm install -D typescript @types/express @types/node

import express, { Request, Response, NextFunction } from "express";

const app = express();
app.use(express.json());


// ── Typed request bodies ──────────────────────────
interface CreateUserBody {
    username: string;
    email:    string;
    password: string;
}

interface LoginBody {
    email:    string;
    password: string;
}


// ── Typed URL parameters ──────────────────────────
interface UserParams {
    id: string;
}


// ── Typed query parameters ────────────────────────
interface CourseQuery {
    level?:    string;
    language?: string;
    page?:     string;
}


// ── Route handlers with full typing ───────────────
app.post(
    "/api/auth/register",
    (req: Request<{}, {}, CreateUserBody>, res: Response) => {
        const { username, email, password } = req.body;
        // TypeScript knows all three fields exist and are strings
        if (!username || !email || !password) {
            return res.status(400).json({ error: "All fields required" });
        }
        // ... create user logic ...
        res.status(201).json({ message: `User ${username} created` });
    }
);

app.get(
    "/api/users/:id",
    async (req: Request<UserParams>, res: Response) => {
        const userId = parseInt(req.params.id, 10);
        if (isNaN(userId)) {
            return res.status(400).json({ error: "Invalid user ID" });
        }
        // ... fetch user logic ...
        res.json({ id: userId, username: "ahmed", xp: 1500 });
    }
);

app.get(
    "/api/courses",
    (req: Request<{}, {}, {}, CourseQuery>, res: Response) => {
        const { level, language, page = "1" } = req.query;
        const pageNum = parseInt(page, 10);
        // ... filter courses logic ...
        res.json({ courses: [], page: pageNum, level, language });
    }
);


// ── Typed middleware ───────────────────────────────
interface AuthRequest extends Request {
    user?: { id: number; username: string; role: string };
}

function requireAuth(req: AuthRequest, res: Response, next: NextFunction) {
    const username = req.headers["x-username"] as string;
    if (!username) {
        return res.status(401).json({ error: "Authentication required" });
    }
    req.user = { id: 1, username, role: "student" };   // attach to request
    next();
}

app.get("/api/profile", requireAuth, (req: AuthRequest, res: Response) => {
    res.json({ user: req.user });   // TypeScript knows req.user may be undefined
});


const PORT = 3001;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));',
'typescript', 9, 20),


(@ts_id, 'TypeScript Configuration and Real Project Setup',
'tsconfig.json is the control panel for the TypeScript compiler. Understanding the most important options helps you set up projects correctly and get maximum benefit from the type system. Strict mode should be enabled in every new project — it turns on a set of checks that catch the most common bugs.

A real TypeScript project follows a clear structure: source files in src/, compiled output in dist/, strict mode on, path aliases for clean imports, and a build script in package.json. Understanding this setup is what separates someone who uses TypeScript from someone who uses it well.',
'// TypeScript Project Setup — tsconfig and real structure
// ─────────────────────────────────────────────────────

// ══════════════════════════════════════════════════════
// FILE: tsconfig.json
// ══════════════════════════════════════════════════════
// {
//   "compilerOptions": {
//     "target": "ES2022",        // compile to this JS version
//     "module": "commonjs",      // Node.js module format
//     "lib": ["ES2022"],         // include type definitions for these APIs
//     "outDir": "./dist",        // compiled output goes here
//     "rootDir": "./src",        // source files live here
//     "strict": true,            // enable ALL strict checks (do this always)
//     "noImplicitAny": true,     // disallow implicit ''any'' types
//     "strictNullChecks": true,  // null and undefined are distinct types
//     "noImplicitReturns": true, // every code path must return a value
//     "noUnusedLocals": true,    // warn about unused variables
//     "esModuleInterop": true,   // allow default imports from CJS modules
//     "resolveJsonModule": true, // allow importing .json files
//     "baseUrl": "./src",        // for path aliases
//     "paths": {
//       "@/utils/*": ["utils/*"],
//       "@/types/*": ["types/*"]
//     }
//   },
//   "include": ["src/**/*"],
//   "exclude": ["node_modules", "dist"]
// }


// ══════════════════════════════════════════════════════
// FILE: src/types/index.ts  — all shared types in one place
// ══════════════════════════════════════════════════════
export interface User {
    id:        number;
    username:  string;
    email:     string;
    xp:        number;
    createdAt: Date;
}

export interface Course {
    id:       number;
    title:    string;
    language: string;
    level:    CourseLevel;
    lessons:  number;
}

export type CourseLevel = "Beginner" | "Intermediate" | "Advanced";

export type ApiResponse<T> = {
    success: true;
    data:    T;
} | {
    success: false;
    error:   string;
    code:    number;
};


// ══════════════════════════════════════════════════════
// FILE: src/utils/validate.ts
// ══════════════════════════════════════════════════════
export function isValidEmail(email: string): boolean {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

export function isNonEmpty(value: unknown): value is string {
    return typeof value === "string" && value.trim().length > 0;
}

export function clamp(value: number, min: number, max: number): number {
    return Math.min(Math.max(value, min), max);
}


// ══════════════════════════════════════════════════════
// FILE: src/index.ts  — entry point
// ══════════════════════════════════════════════════════
import { User, Course, ApiResponse } from "@/types";    // path alias
import { isValidEmail, isNonEmpty }  from "@/utils/validate";

function handleApiResponse<T>(response: ApiResponse<T>): T {
    if (!response.success) {
        throw new Error(`API Error ${response.code}: ${response.error}`);
    }
    return response.data;
}

const mockResponse: ApiResponse<User[]> = {
    success: true,
    data: [
        { id: 1, username: "ahmed", email: "ahmed@email.com", xp: 1500, createdAt: new Date() }
    ]
};

const users = handleApiResponse(mockResponse);
users.forEach(u => console.log(`${u.username} — ${u.xp} XP`));

console.log(isValidEmail("ahmed@email.com"));   // true
console.log(isNonEmpty("hello"));               // true
console.log(isNonEmpty("  "));                  // false

// ── Build and run ──────────────────────────────────
// package.json scripts:
// "build":     "tsc"
// "dev":       "ts-node-dev --respawn src/index.ts"
// "typecheck": "tsc --noEmit"
// "lint":      "eslint src --ext .ts"',
'typescript', 10, 20);

UPDATE courses SET lessons = 10 WHERE language = 'typescript';


-- ═══════════════════════════════════════════════════════════
--  REACT — lessons 6 to 10
-- ═══════════════════════════════════════════════════════════

SET @react_id = (SELECT id FROM courses WHERE language = 'react' LIMIT 1);

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@react_id, 'Custom Hooks — Reusable Stateful Logic',
'A custom hook is a JavaScript function whose name starts with "use" and that calls other hooks. It lets you extract stateful logic from a component into a reusable function. Instead of copying the same fetch-and-store pattern into five different components, you write it once as a custom hook and use it everywhere.

Custom hooks are the primary way to share non-UI logic in React. They are not components — they return data and functions, not JSX. The "use" prefix is important: React uses it to enforce the Rules of Hooks (hooks must be called at the top level, not inside conditions or loops).',
'// React — Custom Hooks
// ─────────────────────────────────────────────
import { useState, useEffect, useCallback } from "react";


// ── useFetch — fetch any API endpoint ─────────────
function useFetch(url) {
    const [data,    setData]    = useState(null);
    const [loading, setLoading] = useState(true);
    const [error,   setError]   = useState(null);

    useEffect(() => {
        let cancelled = false;   // prevent state update after unmount

        async function load() {
            try {
                setLoading(true);
                setError(null);
                const res = await fetch(url);
                if (!res.ok) throw new Error(`HTTP ${res.status}`);
                const json = await res.json();
                if (!cancelled) setData(json);
            } catch (err) {
                if (!cancelled) setError(err.message);
            } finally {
                if (!cancelled) setLoading(false);
            }
        }

        load();
        return () => { cancelled = true; };   // cleanup: mark as cancelled on unmount
    }, [url]);   // re-fetch when URL changes

    return { data, loading, error };
}


// ── useLocalStorage — persisted state ─────────────
function useLocalStorage(key, initialValue) {
    const [value, setValue] = useState(() => {
        try {
            const stored = localStorage.getItem(key);
            return stored ? JSON.parse(stored) : initialValue;
        } catch {
            return initialValue;
        }
    });

    const set = useCallback((newValue) => {
        setValue(newValue);
        localStorage.setItem(key, JSON.stringify(newValue));
    }, [key]);

    return [value, set];
}


// ── useDebounce — delay rapid updates ─────────────
function useDebounce(value, delay = 300) {
    const [debounced, setDebounced] = useState(value);

    useEffect(() => {
        const timer = setTimeout(() => setDebounced(value), delay);
        return () => clearTimeout(timer);   // cancel on next keystroke
    }, [value, delay]);

    return debounced;
}


// ── Using all three hooks together ────────────────
function CourseSearch() {
    const [query,   setQuery]   = useLocalStorage("last_search", "");
    const debounced             = useDebounce(query, 400);
    const { data: courses, loading, error } = useFetch(
        debounced ? `/api/courses?q=${encodeURIComponent(debounced)}` : "/api/courses"
    );

    return (
        <div>
            <input
                value={query}
                onChange={e => setQuery(e.target.value)}
                placeholder="Search courses..."
            />
            {loading && <p>Loading...</p>}
            {error   && <p style={{color:"red"}}>Error: {error}</p>}
            {courses?.map(c => (
                <div key={c.id}>{c.title}</div>
            ))}
        </div>
    );
}

export { useFetch, useLocalStorage, useDebounce };',
'javascript', 6, 20),


(@react_id, 'Context API — Global State Without Prop Drilling',
'Prop drilling is when you pass data through many layers of components just to get it from a top-level component to a deeply nested one. Every intermediate component that does not use the data still has to pass it along. Context solves this by providing a way to share values across the component tree without explicitly passing them as props.

React.createContext() creates a context object. A Provider component wraps the part of the tree that needs access to the data. Any component inside the Provider can call useContext() to read the current value — without any props.

Context is best for truly global state: the logged-in user, the current theme, the user''s locale. For complex state management in large apps, libraries like Zustand or Redux build on top of these same ideas.',
'// React — Context API
// ─────────────────────────────────────────────
import React, { createContext, useContext, useState, useCallback } from "react";


// ── Create the context ────────────────────────────
const AuthContext = createContext(null);

// ── Provider component — wraps the whole app ──────
function AuthProvider({ children }) {
    const [user, setUser] = useState(() => {
        // Initialise from localStorage so login survives refresh
        const stored = localStorage.getItem("coder_user");
        return stored ? JSON.parse(stored) : null;
    });

    const login = useCallback(async (email, password) => {
        const res = await fetch("/api/auth/login", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ email, password }),
        });
        if (!res.ok) {
            const { error } = await res.json();
            throw new Error(error);
        }
        const data = await res.json();
        setUser(data.user);
        localStorage.setItem("coder_user", JSON.stringify(data.user));
    }, []);

    const logout = useCallback(() => {
        setUser(null);
        localStorage.removeItem("coder_user");
    }, []);

    const value = { user, login, logout, isLoggedIn: !!user };

    return (
        <AuthContext.Provider value={value}>
            {children}
        </AuthContext.Provider>
    );
}

// ── Custom hook — clean access to context ──────────
function useAuth() {
    const context = useContext(AuthContext);
    if (!context) throw new Error("useAuth must be used inside AuthProvider");
    return context;
}


// ── Components that consume the context ───────────
function Navbar() {
    const { user, logout, isLoggedIn } = useAuth();

    return (
        <nav>
            <span>Coder.</span>
            {isLoggedIn
                ? <div>
                    <span>{user.username}</span>
                    <button onClick={logout}>Log Out</button>
                  </div>
                : <a href="/login">Log In</a>
            }
        </nav>
    );
}

function ProtectedPage({ children }) {
    const { isLoggedIn } = useAuth();

    if (!isLoggedIn) {
        return <div>Please log in to view this page.</div>;
    }
    return children;
}

function ProfileCard() {
    const { user } = useAuth();  // no props needed — reads from context
    return <div>Welcome, {user?.username}! You have {user?.xp} XP.</div>;
}


// ── App wraps everything in the provider ──────────
function App() {
    return (
        <AuthProvider>
            <Navbar />
            <ProtectedPage>
                <ProfileCard />
            </ProtectedPage>
        </AuthProvider>
    );
}

export { AuthProvider, useAuth };',
'javascript', 7, 20),


(@react_id, 'Forms and Validation in React',
'Forms in React are controlled — the React state is the single source of truth for the input values. Every keystroke updates the state, and the input''s value is always what the state says. This is different from uncontrolled forms where the DOM holds the values and you extract them with a ref.

Controlled inputs make validation straightforward: validate the state on submit (or on blur for better UX), set error messages in state, and display them next to the relevant fields. Real form validation in production uses libraries like React Hook Form (for performance) or Formik (for completeness), but understanding the manual approach makes those libraries much easier to use.',
'// React — Forms and Validation
// ─────────────────────────────────────────────
import React, { useState } from "react";


// ── Reusable input component ───────────────────────
function FormField({ label, name, type = "text", value, onChange, error }) {
    return (
        <div style={{ marginBottom: "16px" }}>
            <label style={{ display: "block", marginBottom: "4px", fontWeight: "600" }}>
                {label}
            </label>
            <input
                type={type}
                name={name}
                value={value}
                onChange={onChange}
                style={{
                    width: "100%",
                    padding: "10px 12px",
                    borderRadius: "6px",
                    border: `1px solid ${error ? "#ff6b6b" : "rgba(255,255,255,0.15)"}`,
                    background: "#1a1a2e",
                    color: "white",
                    fontSize: "0.95rem",
                }}
            />
            {error && <p style={{ color: "#ff6b6b", fontSize: "0.8rem", marginTop: "4px" }}>{error}</p>}
        </div>
    );
}


// ── Validation logic (pure functions — easy to test) ─
function validateRegistration({ username, email, password, confirm }) {
    const errors = {};
    if (!username.trim())         errors.username = "Username is required";
    else if (username.length < 3) errors.username = "Username must be at least 3 characters";
    else if (username.length > 50) errors.username = "Username must be 50 characters or fewer";
    if (!email.includes("@"))     errors.email    = "Please enter a valid email address";
    if (password.length < 8)      errors.password = "Password must be at least 8 characters";
    if (password !== confirm)      errors.confirm  = "Passwords do not match";
    return errors;
}


// ── Registration form ─────────────────────────────
function RegisterForm() {
    const [form, setForm] = useState({
        username: "", email: "", password: "", confirm: ""
    });
    const [errors,   setErrors]   = useState({});
    const [loading,  setLoading]  = useState(false);
    const [success,  setSuccess]  = useState(false);

    function handleChange(e) {
        const { name, value } = e.target;
        setForm(prev => ({ ...prev, [name]: value }));
        // Clear error for this field as the user types
        if (errors[name]) setErrors(prev => ({ ...prev, [name]: "" }));
    }

    async function handleSubmit(e) {
        e.preventDefault();
        const validation = validateRegistration(form);
        if (Object.keys(validation).length > 0) {
            setErrors(validation);
            return;
        }

        setLoading(true);
        try {
            const res = await fetch("/api/auth/register", {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify({ username: form.username, email: form.email, password: form.password }),
            });
            if (!res.ok) {
                const data = await res.json();
                setErrors({ submit: data.error });
                return;
            }
            setSuccess(true);
        } catch {
            setErrors({ submit: "Network error. Please try again." });
        } finally {
            setLoading(false);
        }
    }

    if (success) return <div style={{color:"#43e97b"}}>Account created! Welcome to Coder.</div>;

    return (
        <form onSubmit={handleSubmit} style={{ maxWidth: "400px", padding: "24px" }}>
            <h2>Create Account</h2>
            <FormField label="Username" name="username" value={form.username} onChange={handleChange} error={errors.username} />
            <FormField label="Email"    name="email"    value={form.email}    onChange={handleChange} error={errors.email} type="email" />
            <FormField label="Password" name="password" value={form.password} onChange={handleChange} error={errors.password} type="password" />
            <FormField label="Confirm"  name="confirm"  value={form.confirm}  onChange={handleChange} error={errors.confirm}  type="password" />
            {errors.submit && <p style={{color:"#ff6b6b"}}>{errors.submit}</p>}
            <button type="submit" disabled={loading} style={{ width:"100%", padding:"12px", background:"#6c63ff", color:"white", border:"none", borderRadius:"6px", cursor:"pointer" }}>
                {loading ? "Creating account..." : "Register"}
            </button>
        </form>
    );
}

export default RegisterForm;',
'javascript', 8, 20),


(@react_id, 'Performance Optimisation — useMemo and useCallback',
'React re-renders a component every time its state or props change. For most components this is fine — React is fast. But if a component does an expensive calculation or renders a large list, unnecessary re-renders become a performance problem. React provides three hooks to optimise this: useMemo, useCallback, and React.memo.

useMemo memoizes the result of a calculation — it only recomputes when its dependencies change. useCallback memoizes a function — it returns the same function reference unless dependencies change. This matters because passing a new function reference as a prop causes the child to re-render even if the function does the same thing. React.memo wraps a component and skips re-rendering if props have not changed.

The golden rule: do not optimise prematurely. Use React DevTools Profiler to identify actual performance bottlenecks first. These tools add their own complexity and are only worth it when the bottleneck is real.',
'// React — useMemo, useCallback, React.memo
// ─────────────────────────────────────────────
import React, { useState, useMemo, useCallback, memo } from "react";


// ── useMemo — expensive calculation ───────────────
function CourseStats({ courses }) {
    const [filter, setFilter] = useState("all");

    // This runs on EVERY render without useMemo
    // const stats = computeStats(courses);   // slow!

    // With useMemo: only recomputes when courses changes
    const stats = useMemo(() => {
        console.log("Computing stats...");   // you will see this less often
        return {
            total:        courses.length,
            byLevel: {
                beginner:     courses.filter(c => c.level === "Beginner").length,
                intermediate: courses.filter(c => c.level === "Intermediate").length,
                advanced:     courses.filter(c => c.level === "Advanced").length,
            },
            avgLessons: courses.reduce((sum, c) => sum + c.lessons, 0) / courses.length,
        };
    }, [courses]);   // only recompute when courses array changes

    const filtered = useMemo(
        () => filter === "all" ? courses : courses.filter(c => c.level === filter),
        [courses, filter]
    );

    return (
        <div>
            <p>Total: {stats.total} | Avg lessons: {stats.avgLessons.toFixed(1)}</p>
            <select value={filter} onChange={e => setFilter(e.target.value)}>
                <option value="all">All</option>
                <option value="Beginner">Beginner</option>
                <option value="Intermediate">Intermediate</option>
            </select>
            {filtered.map(c => <div key={c.id}>{c.title}</div>)}
        </div>
    );
}


// ── useCallback — stable function references ───────
function LessonList({ courseId }) {
    const [completed, setCompleted] = useState(new Set());

    // Without useCallback: new function on every render → TodoItem always re-renders
    // With useCallback: same function reference if dependencies unchanged
    const handleComplete = useCallback((lessonId) => {
        setCompleted(prev => new Set([...prev, lessonId]));
    }, []);   // no dependencies — function never changes

    const handleUncomplete = useCallback((lessonId) => {
        setCompleted(prev => {
            const next = new Set(prev);
            next.delete(lessonId);
            return next;
        });
    }, []);

    // ... render lessons, passing handleComplete as prop
    return <div>Lesson list for course {courseId}</div>;
}


// ── React.memo — skip re-render if props unchanged ─
const LessonItem = memo(function LessonItem({ lesson, onComplete, isCompleted }) {
    console.log("Rendering:", lesson.title);   // only logs when props actually change

    return (
        <div style={{ display:"flex", gap:"12px", padding:"12px", background: isCompleted ? "#1a2e1a" : "#1a1a2e", borderRadius:"8px", marginBottom:"8px" }}>
            <span style={{ flex:1 }}>{lesson.title}</span>
            <span style={{ color:"#43e97b" }}>{lesson.xp_reward} XP</span>
            <button
                onClick={() => onComplete(lesson.id)}
                disabled={isCompleted}
                style={{ padding:"4px 12px", background: isCompleted ? "#2a2a2a" : "#6c63ff", color:"white", border:"none", borderRadius:"4px", cursor: isCompleted ? "default" : "pointer" }}
            >
                {isCompleted ? "Done ✓" : "Complete"}
            </button>
        </div>
    );
});
// Now LessonItem only re-renders when lesson, onComplete, or isCompleted changes
// Not when the parent re-renders for an unrelated reason

export { LessonItem };',
'javascript', 9, 20),


(@react_id, 'Build a Full React App — Course Platform',
'This lesson builds a mini version of Coder itself using React — a multi-page app with authentication state, a course list, and a lesson viewer. It demonstrates every React concept covered in this course working together in a realistic structure.',
'// Full React App — Mini Coder Platform
// ─────────────────────────────────────────────
import React, { useState, useEffect, createContext, useContext } from "react";


// ══════════════════════════════════════════════════
// CONTEXT — global auth state
// ══════════════════════════════════════════════════
const AuthContext = createContext(null);
const useAuth = () => useContext(AuthContext);

function AuthProvider({ children }) {
    const [user, setUser] = useState(
        () => JSON.parse(localStorage.getItem("app_user") || "null")
    );
    const login  = (u) => { setUser(u); localStorage.setItem("app_user", JSON.stringify(u)); };
    const logout = ()  => { setUser(null); localStorage.removeItem("app_user"); };
    return <AuthContext.Provider value={{ user, login, logout }}>{children}</AuthContext.Provider>;
}


// ══════════════════════════════════════════════════
// HOOKS
// ══════════════════════════════════════════════════
function useFetch(url) {
    const [state, setState] = useState({ data: null, loading: true, error: null });
    useEffect(() => {
        setState(s => ({ ...s, loading: true }));
        fetch(url)
            .then(r => r.ok ? r.json() : Promise.reject(`HTTP ${r.status}`))
            .then(data => setState({ data, loading: false, error: null }))
            .catch(err => setState({ data: null, loading: false, error: String(err) }));
    }, [url]);
    return state;
}


// ══════════════════════════════════════════════════
// COMPONENTS
// ══════════════════════════════════════════════════
function Nav({ page, setPage }) {
    const { user, logout } = useAuth();
    return (
        <nav style={{ display:"flex", justifyContent:"space-between", alignItems:"center", padding:"0 2rem", height:"60px", borderBottom:"1px solid rgba(255,255,255,0.08)", background:"#0d0d1a" }}>
            <span onClick={() => setPage("home")} style={{ cursor:"pointer", fontWeight:900, color:"#6c63ff", fontSize:"1.3rem" }}>Coder.</span>
            <div style={{ display:"flex", gap:"1rem", alignItems:"center" }}>
                {user
                    ? <><span style={{color:"#8b8ba7"}}>{user.username}</span><button onClick={logout} style={{background:"none",border:"1px solid #444",color:"white",padding:"4px 12px",borderRadius:"6px",cursor:"pointer"}}>Logout</button></>
                    : <button onClick={() => setPage("login")} style={{background:"#6c63ff",border:"none",color:"white",padding:"6px 16px",borderRadius:"6px",cursor:"pointer"}}>Login</button>
                }
            </div>
        </nav>
    );
}

function CourseCard({ course, onClick }) {
    return (
        <div onClick={onClick} style={{ background:"#1a1a2e", border:"1px solid rgba(255,255,255,0.08)", borderTop:`3px solid ${course.color || "#6c63ff"}`, borderRadius:"12px", padding:"20px", cursor:"pointer", transition:"transform 0.2s" }}
             onMouseEnter={e => e.currentTarget.style.transform = "translateY(-4px)"}
             onMouseLeave={e => e.currentTarget.style.transform = "translateY(0)"}>
            <h3 style={{ color: course.color || "#6c63ff", marginBottom:"8px" }}>{course.title}</h3>
            <p style={{ color:"#8b8ba7", fontSize:"0.85rem", marginBottom:"12px" }}>{course.description}</p>
            <span style={{ color:"#8b8ba7", fontSize:"0.78rem" }}>{course.lessons} lessons · {course.level}</span>
        </div>
    );
}

function HomePage({ setPage, setSelected }) {
    const { data: courses, loading, error } = useFetch("/api/courses");
    if (loading) return <p style={{padding:"3rem",textAlign:"center",color:"#8b8ba7"}}>Loading...</p>;
    if (error)   return <p style={{padding:"3rem",textAlign:"center",color:"#ff6b6b"}}>Error: {error}</p>;
    return (
        <main style={{ maxWidth:"1200px", margin:"0 auto", padding:"3rem 2rem" }}>
            <h1 style={{ marginBottom:"2rem" }}>All Courses</h1>
            <div style={{ display:"grid", gridTemplateColumns:"repeat(auto-fit, minmax(280px,1fr))", gap:"1.5rem" }}>
                {courses?.map(c => (
                    <CourseCard key={c.id} course={c} onClick={() => { setSelected(c); setPage("course"); }} />
                ))}
            </div>
        </main>
    );
}

// ══════════════════════════════════════════════════
// APP ROOT
// ══════════════════════════════════════════════════
function App() {
    const [page,     setPage]     = useState("home");
    const [selected, setSelected] = useState(null);

    return (
        <AuthProvider>
            <div style={{ minHeight:"100vh", background:"#0d0d1a", color:"#e8e8f0", fontFamily:"system-ui,sans-serif" }}>
                <Nav page={page} setPage={setPage} />
                {page === "home"   && <HomePage setPage={setPage} setSelected={setSelected} />}
                {page === "course" && selected && <div style={{padding:"3rem 2rem"}}><h2>{selected.title}</h2><p style={{color:"#8b8ba7"}}>{selected.description}</p></div>}
            </div>
        </AuthProvider>
    );
}

export default App;',
'javascript', 10, 20);

UPDATE courses SET lessons = 10 WHERE language = 'react';


-- ═══════════════════════════════════════════════════════════
--  GIT & GITHUB — lessons 6 to 10
-- ═══════════════════════════════════════════════════════════

SET @git_id = (SELECT id FROM courses WHERE language = 'bash' LIMIT 1);

INSERT IGNORE INTO lessons (course_id, title, content, code_example, language, order_num, xp_reward) VALUES

(@git_id, 'Undoing Mistakes — Reset, Revert, and Restore',
'Git gives you a time machine. When you make a mistake, there is almost always a safe way to undo it. The key is choosing the right tool based on whether the commit is public (shared with others) or private (only on your machine), and how much you want to undo.

git restore undoes changes to working files before they are committed. git reset undoes commits by moving the branch pointer backwards. git revert creates a new commit that undoes the changes of a previous commit — this is the safe way to undo something that has already been pushed.',
'# Git — Undoing Mistakes
# ─────────────────────────────────────────────────

# ── Undo changes to a file BEFORE staging ─────────
git restore filename.js       # discard changes to one file
git restore .                 # discard ALL unstaged changes (irreversible!)


# ── Unstage a file (was added but not yet committed) ──
git restore --staged filename.js    # remove from staging, keep changes in file
# Alternative older syntax:
git reset HEAD filename.js


# ── Undo the last commit — keep changes ───────────
git reset --soft HEAD~1     # undo commit, changes remain staged
git reset HEAD~1            # undo commit, changes remain in files (unstaged)

# Undo the last 3 commits
git reset HEAD~3


# ── DANGER: Undo last commit AND discard changes ──
git reset --hard HEAD~1     # WARNING: changes are lost permanently
# Only use this when you are 100% sure the changes are worthless


# ── The SAFE way to undo a public commit ──────────
# git reset on a public commit is dangerous — it rewrites history
# others have already downloaded. Use git revert instead.

git revert abc1234          # creates a new commit that undoes abc1234
# Safe to push — history is not rewritten, just extended


# ── Revert the last commit ─────────────────────────
git revert HEAD
# Opens your editor to confirm the revert commit message
# Use --no-edit to skip the editor:
git revert HEAD --no-edit


# ── Find a lost commit with reflog ─────────────────
# Git never truly deletes commits — they stay in the reflog for 30 days
git reflog
# Output:
# a3f9c2e HEAD@{0}: reset: moving to HEAD~1   ← the reset
# 8d1e4b1 HEAD@{1}: commit: Add login page    ← the "lost" commit

# Recover it:
git checkout 8d1e4b1         # go back to that commit
# OR
git reset --hard 8d1e4b1    # reset branch to that commit


# ── Summary: which tool to use ────────────────────
# Changes not yet staged       → git restore <file>
# Changes staged, not committed → git restore --staged <file>
# Local commit (not pushed)    → git reset HEAD~1
# Public commit (already pushed) → git revert <hash>',
'bash', 6, 20),


(@git_id, 'Advanced Git — Stash, Tags, and Cherry-Pick',
'Git stash temporarily shelves your uncommitted changes so you can switch tasks without losing work or making a premature commit. It is perfect for the moment when you are halfway through a feature and an urgent bug fix comes in — stash your work, fix the bug, then pop your stash and resume.

Tags mark specific commits as important, usually release versions. Git supports lightweight tags (just a pointer) and annotated tags (full objects with a message, date, and author — use these for releases). Cherry-pick lets you copy a specific commit from one branch and apply it to another — great for backporting a bug fix to an older release branch.',
'# Advanced Git — Stash, Tags, Cherry-Pick
# ─────────────────────────────────────────────────

# ══════════════════════════════════════════════════
#  STASH — save work in progress temporarily
# ══════════════════════════════════════════════════

# You are mid-feature when an urgent bug is reported...
git stash                  # shelve all uncommitted changes
git stash push -m "WIP: user profile redesign"   # with a description

# Fix the bug on main
git switch main
git pull
# ... make fix ...
git add fix.js && git commit -m "Fix: null pointer in login"

# Go back to your feature and restore the stash
git switch feature/profile
git stash pop              # apply most recent stash and remove it from stash list
# OR
git stash apply stash@{0}  # apply without removing (keep it in the list)

# See all stashes
git stash list
# stash@{0}: On feature/profile: WIP: user profile redesign
# stash@{1}: On main: quick experiment

# Delete a stash
git stash drop stash@{1}
git stash clear            # delete ALL stashes


# ══════════════════════════════════════════════════
#  TAGS — mark releases
# ══════════════════════════════════════════════════

# Annotated tag — use for releases
git tag -a v1.0.0 -m "First stable release"

# Tag a specific past commit
git tag -a v0.9.0 -m "Beta release" abc1234

# Push tags to GitHub (they are NOT pushed by default)
git push origin v1.0.0     # push one tag
git push origin --tags     # push ALL tags

# List and show tags
git tag -l
git show v1.0.0


# ══════════════════════════════════════════════════
#  CHERRY-PICK — copy one commit to another branch
# ══════════════════════════════════════════════════

# You fixed a critical bug on the main branch.
# The fix is in commit d3f1a2b.
# You need the same fix on the release/v1 branch.

git switch release/v1
git cherry-pick d3f1a2b    # applies that ONE commit here

# Cherry-pick multiple commits
git cherry-pick d3f1a2b e4g2b3c

# Cherry-pick a range
git cherry-pick d3f1a2b..e4g2b3c   # all commits between (exclusive of first)

# If there is a conflict during cherry-pick:
# 1. Fix the conflicted files
# 2. git add fixed-file.js
# 3. git cherry-pick --continue
# OR
# git cherry-pick --abort   (cancel the whole operation)',
'bash', 7, 20),


(@git_id, 'GitHub Issues, Pull Requests, and Code Review',
'Pull requests and issues are the collaboration layer on top of Git. Issues track bugs, feature requests, and tasks. Pull requests propose changes, trigger automated checks, and gather human review before code merges into main. Together they form the professional workflow used by virtually every software team in the world.

A good PR is small (under 400 lines of change), has a clear description explaining what changed and why, references the issue it closes, and passes all automated tests. A good code review is constructive — it focuses on the code, not the person, asks questions rather than demanding changes, and approves promptly when the work is good enough.',
'# GitHub Issues and Pull Requests
# ─────────────────────────────────────────────────

# ══════════════════════════════════════════════════
#  ISSUES
# ══════════════════════════════════════════════════

# Open an issue on GitHub when you find a bug:
# Title:       "Compiler returns 500 error for Java code with unicode comments"
# Description:
#   ## Steps to reproduce
#   1. Go to the compiler
#   2. Select Java
#   3. Paste code with // comment containing Arabic text
#   4. Click Run
#
#   ## Expected behaviour
#   Code runs and output is shown
#
#   ## Actual behaviour
#   500 Internal Server Error
#
#   ## Environment
#   Windows 11, Chrome 125
#
# Good issues get fixed faster — they are reproducible and clear.


# ══════════════════════════════════════════════════
#  LINKING COMMITS AND PRs TO ISSUES
# ══════════════════════════════════════════════════

# In a commit message:
git commit -m "Fix: handle unicode in Java compiler (#42)"
#                                                   ^^^^ references issue 42

# In a PR description, to close the issue automatically on merge:
# "Closes #42" or "Fixes #42" or "Resolves #42"
# GitHub will close issue #42 when the PR is merged into main.


# ══════════════════════════════════════════════════
#  THE FULL PR WORKFLOW
# ══════════════════════════════════════════════════

# 1. Create a well-named branch
git switch -c fix/java-unicode-compiler-error

# 2. Make the fix in small, focused commits
git add server/routes/compiler.js
git commit -m "Fix: add -encoding UTF-8 flag to javac command"

git add tests/compiler.test.js
git commit -m "Test: add unicode comment test for Java compiler"

# 3. Push and create PR
git push -u origin fix/java-unicode-compiler-error
# → GitHub shows: "Compare & pull request" banner — click it

# PR description template:
# ## What changed
# Added -encoding UTF-8 flag to the javac command in compiler.js
# so that source files with unicode characters compile correctly.
#
# ## Why
# Fixes #42 — Java files with non-ASCII comments caused a 500 error
# because javac defaulted to the system locale (cp1252 on Windows).
#
# ## Test plan
# - [ ] Manually tested Java unicode code in compiler
# - [ ] New unit test added and passing
# - [ ] No regressions in other language tests
#
# Fixes #42

# 4. Review and address feedback
# Reviewer says: "Can you also add a test for Chinese characters?"
# You add the test, commit, and push — the PR updates automatically.

# 5. Merge (on GitHub, click "Squash and merge" or "Merge pull request")

# 6. Clean up
git switch main
git pull
git branch -d fix/java-unicode-compiler-error',
'bash', 8, 20),


(@git_id, 'GitHub Actions — Automate Everything',
'GitHub Actions is a CI/CD (Continuous Integration / Continuous Deployment) platform built into GitHub. Every time you push code or open a pull request, GitHub can automatically run your tests, lint your code, build your project, and deploy it — all configured in YAML files inside your repository.

A workflow is a YAML file in .github/workflows/. It defines: when to run (on push, on PR, on a schedule), what environment to run in (ubuntu-latest, windows-latest, macos-latest), and what steps to execute. Each step is either a shell command or a pre-built action from the GitHub Actions marketplace.',
'# GitHub Actions — CI/CD Workflows
# ─────────────────────────────────────────────────

# ══════════════════════════════════════════════════
# FILE: .github/workflows/ci.yml
# Runs on every push and pull request to main
# ══════════════════════════════════════════════════

# name: CI
#
# on:
#   push:
#     branches: [main]
#   pull_request:
#     branches: [main]
#
# jobs:
#   test:
#     runs-on: ubuntu-latest
#
#     steps:
#       - name: Checkout code
#         uses: actions/checkout@v4
#
#       - name: Set up Node.js
#         uses: actions/setup-node@v4
#         with:
#           node-version: "20"
#           cache: "npm"
#
#       - name: Install dependencies
#         run: npm ci               # like npm install but deterministic
#
#       - name: Run linter
#         run: npm run lint
#
#       - name: Run tests
#         run: npm test
#
#       - name: Build
#         run: npm run build


# ══════════════════════════════════════════════════
# FILE: .github/workflows/deploy.yml
# Deploy to production on push to main only
# ══════════════════════════════════════════════════

# name: Deploy
#
# on:
#   push:
#     branches: [main]
#
# jobs:
#   deploy:
#     runs-on: ubuntu-latest
#     needs: test          # only deploy if CI passes
#
#     steps:
#       - uses: actions/checkout@v4
#
#       - name: Deploy to server
#         env:
#           SSH_KEY: ${{ secrets.DEPLOY_SSH_KEY }}    # stored in GitHub Secrets
#           SERVER:  ${{ secrets.DEPLOY_HOST }}
#         run: |
#           echo "$SSH_KEY" > /tmp/deploy_key
#           chmod 600 /tmp/deploy_key
#           ssh -i /tmp/deploy_key user@$SERVER "cd /app && git pull && npm install && pm2 restart all"


# ══════════════════════════════════════════════════
# KEY CONCEPTS
# ══════════════════════════════════════════════════

# Secrets — store sensitive values (API keys, passwords) in GitHub
# Settings → Secrets and variables → Actions → New repository secret
# Access in workflow: ${{ secrets.SECRET_NAME }}
# Never hardcode secrets in your workflow YAML — it is in your git history!

# Matrix — test across multiple versions
# strategy:
#   matrix:
#     node-version: [18, 20, 22]
# This runs the job 3 times in parallel, once per Node version.

# Artifacts — save files from a workflow run (test reports, build output)
# - uses: actions/upload-artifact@v4
#   with:
#     name: build-output
#     path: dist/

# Status badge — show CI status in your README
# ![CI](https://github.com/username/repo/actions/workflows/ci.yml/badge.svg)',
'bash', 9, 20),


(@git_id, 'Contributing to Open Source — The Full Workflow',
'Open source is where the best developers learn. Contributing to real projects that millions of people use teaches you more than any course. The workflow — fork, clone, branch, change, test, push, PR — is the same whether you are fixing a typo in documentation or adding a major feature to a popular library.

Finding your first contribution: look for issues labelled "good first issue" or "help wanted". Start with documentation, tests, or small bug fixes. Read the CONTRIBUTING.md file in the repository — it explains the project''s specific conventions. Run the existing tests before making any changes to make sure the project builds on your machine.',
'# Contributing to Open Source
# ─────────────────────────────────────────────────

# ══════════════════════════════════════════════════
# THE COMPLETE FORK-AND-PR WORKFLOW
# ══════════════════════════════════════════════════

# STEP 1: Fork the repository on GitHub
# (Click "Fork" on the repo''s GitHub page — creates your copy)


# STEP 2: Clone YOUR fork
git clone https://github.com/YOUR-USERNAME/the-project.git
cd the-project


# STEP 3: Add the ORIGINAL repo as "upstream"
# This lets you pull in future updates from the original
git remote add upstream https://github.com/ORIGINAL-OWNER/the-project.git
git remote -v
# origin   https://github.com/YOUR-USERNAME/the-project.git (your fork)
# upstream https://github.com/ORIGINAL-OWNER/the-project.git (original)


# STEP 4: Create a branch for your contribution
git switch -c fix/typo-in-readme


# STEP 5: Make your changes, commit them
# Read CONTRIBUTING.md first for the project''s style rules!
git add README.md
git commit -m "Fix: correct spelling of ''JavaScript'' in introduction"


# STEP 6: Before pushing, sync with upstream to avoid conflicts
git fetch upstream
git rebase upstream/main    # replay your commits on top of latest main


# STEP 7: Push to YOUR fork and open a PR
git push origin fix/typo-in-readme
# Go to github.com/YOUR-USERNAME/the-project
# Click "Compare & pull request"
# Write a clear description, reference any related issue


# ══════════════════════════════════════════════════
# KEEPING YOUR FORK UP TO DATE
# ══════════════════════════════════════════════════

# When the original repo gets new commits:
git fetch upstream
git switch main
git merge upstream/main    # fast-forward your local main
git push origin main       # update your fork on GitHub


# ══════════════════════════════════════════════════
# WRITING A GOOD FIRST CONTRIBUTION
# ══════════════════════════════════════════════════

# Checklist before submitting:
# [ ] Read CONTRIBUTING.md — follow the project''s conventions
# [ ] Run the test suite: npm test / python -m pytest / go test ./...
# [ ] Add a test for your change if applicable
# [ ] Keep the change small and focused — one thing per PR
# [ ] Respond to reviewer feedback promptly and graciously
# [ ] Don''t take code review personally — it''s about the code

# Good places to find your first issue:
# https://goodfirstissue.dev
# https://github.com/explore  → filter by topic
# Search GitHub: label:"good first issue" language:python

# Remember: even a one-word typo fix is a real contribution.
# Every expert open source contributor started with something small.',
'bash', 10, 20);

UPDATE courses SET lessons = 10 WHERE language = 'bash';
