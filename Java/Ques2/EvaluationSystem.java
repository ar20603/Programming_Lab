import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.util.*;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

// class to store each student record
class Record {
    Integer RollNo;
    String Name;
    String MailID;
    Integer Marks;
    String Teacher;

    // constructor for the record class
    public Record(Integer rollNo, String name, String mailID, Integer marks, String teacher) {
        RollNo = rollNo;
        Name = name;
        MailID = mailID;
        Marks = marks;
        Teacher = teacher;
    }
    
}

// main class for evaluation system
public class EvaluationSystem {

    // to store logged in user type
    public static String user;

    // filepath where student records are stores
    public static String filepath = "Stud_Info.txt";
    public static Path path = Paths.get(filepath);

    // list to store records when file is read
    public static List<Record> studData = new ArrayList<>();
    
    // main function
    public static void main(String args[]) throws FileNotFoundException, IOException {
        
        // prompt user to take input
        // to know type of user he is: CC or TA1 or TA2
        System.out.println("Are you CC or TA1 or TA2?");
        Scanner sc = new Scanner(System.in);
        user = sc.next();

        // set user type
        while(!user.equals("CC") &&  !user.equals("TA1") && !user.equals("TA2")) {
            System.out.println("Try again. Are you CC or TA1 or TA2?");
            user = sc.next();
        }

        System.out.println("Logged in.");
        
        // create file if not present
        File newFile = new File("Stud_Info.txt");
        newFile.createNewFile();

        // prompting user to read type of operation again and again
        while(true) {
            System.out.println("Which operation do you want to perform:\n" + 
                "Enter 1 to Insert record\n" + 
                "Enter 2 to View record\n" + 
                "Enter 3 to Update record\n" + 
                "Enter 4 to Generate students data in sorted Roll No. order\n" +
                "Enter 5 to Generate students data in sorted Name order\n" +
                "Enter 6 to Exit"
            );
            
            // take input for type of operation
            int operation = sc.nextInt();

            // based on input, call corrresponding function
            if(operation == 1) {
                insertRecord();
            }
            else if(operation == 2) {
                viewRecord();
            }
            else if(operation == 3) {
                updateRecord();
            }
            else if(operation == 4) {
                generatSortedByRoll();
            }
            else if(operation == 5) {
                generatSortedByName();
            }
            else if(operation == 6) {
                // Break while loop and end program
                System.out.println("Have a good day. :)");
                break;
            }
            else {
                System.out.println("Try Again.");
                // Do nothing. Give options again.
            }
        }

        // close scanner
        sc.close();

    }

    // function to read student records from file channel
    private static String readRecordsFromFile(FileChannel channel) throws FileNotFoundException, IOException {
        
        // function to read raw data from channel (as string)
        String data = readDataFromChannel(channel);

        // split to get array of records
        String[] records = data.split("\n");

        // clear the records array to store latest records
        studData.clear();

        // iterate through each record string, create a record object
        // and add it to the records list
        for (String record: records) {
            if(record.equals("")) continue;
            List<String> columns = Arrays.asList(record.split(","));
            Record studRecord = new Record(Integer.parseInt(columns.get(0)), columns.get(1), columns.get(2), Integer.parseInt(columns.get(3)), columns.get(4));
            studData.add(studRecord);
        }

        // return whole string of records
        return data;
    }

    // function to read data as string from file channel
    private static String readDataFromChannel(FileChannel channel) throws IOException {
        String data = "";

        // initialize buffer and read
        ByteBuffer buffer = ByteBuffer.allocate((int) channel.size());
        channel.read(buffer);

        // Flip buffer to position 0 to read it
        buffer.flip();

        // store data in string
        for (int i = 0; i < channel.size(); i++) {
            data += (char)buffer.get();
        }

        return data;
    }


    // function to insert record in file
    private static void insertRecord() throws NumberFormatException, IOException {
        
        // take all the field values as input from user
        System.out.println("To add a new record, input the following data:");
        System.out.print("Roll No.: ");
        
        Scanner sc = new Scanner(System.in);
        String input = sc.nextLine();

        Integer rollNo;
        try {
            rollNo = Integer.parseInt(input);
        } catch (Exception e) {
            System.out.println("Invalid RollNo. Try again");
            return;
        }
        

        System.out.print("Name: ");
        String name = sc.nextLine();

        System.out.print("Mail Id: ");
        String mailID = sc.nextLine();
        
        System.out.print("Marks: ");
        input = sc.nextLine();
        Integer marks;
        try {
            marks = Integer.parseInt(input);
        } catch (Exception e) {
            System.out.println("Invalid RollNo. Try again");
            return;
        }


        // open file channel and get exclusive lock to write
        FileChannel channel = FileChannel.open(path, StandardOpenOption.WRITE, StandardOpenOption.READ);
        FileLock writeLock;
        System.out.println("File maybe in use. Please wait...");
        // thread waits here until it gets the lock
        writeLock = channel.lock();

        // read records from file and load into a list of record ojects
        String data = readRecordsFromFile(channel);

        // if Roll no already exists, infrom user
        if(recordAlreadyExists(rollNo) != null) {
            System.out.println("Record with same Roll No. already exists. Try again. Or you can update that record");
            System.out.println("--------------------------");
            channel.close(); 
            return;
        }

        // create a new record object with input details
        Record studRecord = new Record(rollNo, name, mailID, marks, user);
        studData.add(studRecord);

        String record = rollNo + "," + name + "," + mailID + "," + marks + "," + user + "\n";
        
        data += record;

        // write data to file through channel
        ByteBuffer buf = ByteBuffer.wrap(data.getBytes()); 
        channel.truncate(0);
        channel.write(buf);

        channel.close();    // releases the lock
        System.out.println("Record added. Total " + studData.size() + " records.");
        System.out.println("--------------------------");
    }

    // check in the list of records if a given RollNo exitsts
    private static Record recordAlreadyExists(Integer rollNo) {
        for (Record record : studData) {
            System.out.println(rollNo + " " + record.RollNo);
            if(record.RollNo.equals(rollNo)) {
                return record;
            }
        }

        return null;
    }


    // function to view a student record 
    private static void viewRecord() throws NumberFormatException, IOException {
        
        // promt user to provide Roll No of record to query
        System.out.println("To view a record, input the following data:");
        System.out.print("Roll No.: ");
        Scanner sc = new Scanner(System.in);
        String input = sc.nextLine();
        Integer rollNo;
        try {
            rollNo = Integer.parseInt(input);
        } catch (Exception e) {
            System.out.println("Invalid RollNo");
            return;
        }
        

        // open file channel and obtain a shared read lock
        FileChannel channel = FileChannel.open(path, StandardOpenOption.READ);
        FileLock readLock;
        System.out.println("File maybe in use. Please wait...");
        readLock = channel.lock(0, Long.MAX_VALUE, true);

        // read records from file and load into a list of record ojects
        String data = readRecordsFromFile(channel);
        
        // boolean found: if the queried record exists
        boolean found = false;

        // iterate through each record and match RollNo
        for (Record record : studData) {
            if(record.RollNo.equals(rollNo)) {
                found = true;
                System.out.println(
                    "The record you queried:\n" +
                    "Roll No.: " + Integer.toString(record.RollNo) + "\n" + 
                    "Name: " + record.Name + "\n" + 
                    "MailID: " + record.MailID + "\n" + 
                    "Marks: " + Integer.toString(record.Marks)
                );
                break;
            }
        }

        // if no such record exists
        if(!found) {
            System.out.println("No such record found.");
        }

        channel.close();    // releases the lock
        System.out.println("--------------------------");
    }


    // function to update student record in file
    private static void updateRecord() throws FileNotFoundException, IOException {

        // promt user to provide Roll No of the record to be updated
        System.out.println("To update an existing record, input the following data:");
        System.out.print("Roll No.: ");
        Scanner sc = new Scanner(System.in);
        String input = sc.nextLine();
        Integer rollNo;
        try {
            rollNo = Integer.parseInt(input);
        } catch (Exception e) {
            System.out.println("Invalid RollNo");
            return;
        }
        

        // open file channel and obtain an exclusive write lock
        FileChannel channel = FileChannel.open(path, StandardOpenOption.WRITE, StandardOpenOption.READ);
        FileLock writeLock;
        System.out.println("File maybe in use. Please wait...");
        writeLock = channel.lock();

        // read records from file and load into a list of record ojects
        String data = readRecordsFromFile(channel);

        // return the record if it exists, null if it doesn't
        Record currentRecord = recordAlreadyExists(rollNo);
        if(currentRecord == null) {
            System.out.println("Record with given Roll No. doesn't exist. Try again.");
            System.out.println("--------------------------");
            channel.close(); 
            return;
        }

        System.out.println(
            "The record you want to modify:\n" +
            "Roll No.: " + Integer.toString(currentRecord.RollNo) + "\n" + 
            "Name: " + currentRecord.Name + "\n" + 
            "MailID: " + currentRecord.MailID + "\n" + 
            "Marks: " + Integer.toString(currentRecord.Marks)
        );

        // queried record is updated by CC, restrict TA1, TA2 from updating
        if(currentRecord.Teacher.equals("CC") && user.startsWith("TA", 0)) {
            System.out.println("You are not allowed to edit this record.");
            channel.close();    // releases the lock
            System.out.println("--------------------------");
            return;
        }

        // asking user for the field to update
        System.out.println();
        System.out.println("Which field do you want to modify: \n" +
                "Enter 1 for Name\n" + 
                "Enter 2 for MailID\n" + 
                "Enter 3 for Marks\n" + 
                "Any other number to close\n"
        );
        int field = Integer.parseInt(sc.nextLine());

        // taking the value to be updated int the desired field
        System.out.println("Input the new value: ");
        String newValue = sc.nextLine();

        // based on input field, update it with provided new value
        if(field == 1) {
            currentRecord.Name = newValue;
        }
        else if(field == 2) {
            currentRecord.MailID = newValue;
        }
        else if(field == 3) {
            currentRecord.Marks = Integer.parseInt(newValue);
        }
        else {
            channel.close();
            System.out.println("--------------------------");
            return;
        }

        // mark the user type who edited the file last
        currentRecord.Teacher = user;

        // get data from list of record objects in the from of string to write back in file
        data = getDataFromArray();
        
        // write back in file
        ByteBuffer buf = ByteBuffer.wrap(data.getBytes()); 
        channel.truncate(0);
        channel.write(buf);

        channel.close();    // releases the lock
        System.out.println("Record successfully updated. Total " + studData.size() + " records.");
        System.out.println("--------------------------");
    }

    // function to get data from list of record objects in the from of string to write back in file
    private static String getDataFromArray() {
        String data = "";
        for (Record record : studData) {
            // comma separated fields and
            // '/n' separated records as stored in file
            data += Integer.toString(record.RollNo) + "," + 
                    record.Name + "," + 
                    record.MailID + "," + 
                    Integer.toString(record.Marks) + "," + 
                    record.Teacher + '\n';
        }

        return data;
    }


    // function to generate a file with students' records sorted by Roll No
    private static void generatSortedByRoll() throws FileNotFoundException, IOException  {

        // open file channel and obtain a shared read lock
        FileChannel channel = FileChannel.open(path, StandardOpenOption.READ);
        FileLock readLock;
        System.out.println("File maybe in use. Please wait...");
        readLock = channel.lock(0, Long.MAX_VALUE, true);

        // read records from file and store in list of records an then close channel releasing lock
        readRecordsFromFile(channel);
        channel.close();
        
        // sorting list of student records based on Roll No.
        Collections.sort(studData, (r1, r2) -> r1.RollNo.compareTo(r2.RollNo));

        // create file if it doesn't exist
        File newFile = new File("Sorted_Roll.txt");
        newFile.createNewFile();

        // open channel to with append to append each record one by one 
        channel = FileChannel.open(Paths.get("Sorted_Roll.txt"), StandardOpenOption.APPEND);

        // Adding headers in file
        String headerData = String.format("%-20s", "Roll No.") + 
                            String.format("%-20s", "Name") + 
                            String.format("%-20s", "MailID") + 
                            String.format("%-20s", "Marks") + "\n";

        ByteBuffer buf = ByteBuffer.wrap(headerData.getBytes()); 

        // erasing file
        channel.truncate(0);
        channel.write(buf);

        // iterate over each record and write in the file 
        for (Record record : studData) {
            String recordData = String.format("%-20s", Integer.toString(record.RollNo)) + 
                                String.format("%-20s", record.Name) + 
                                String.format("%-20s", record.MailID) + 
                                String.format("%-20s", Integer.toString(record.Marks)) + "\n";
            
            buf = ByteBuffer.wrap(recordData.getBytes()); 
            channel.write(buf);
        }

        // close channel releasing the lock
        channel.close();
        System.out.println("Sorted_Roll.txt successfully generated.");
    }

    private static void generatSortedByName() throws FileNotFoundException, IOException {

        // open file channel and obtain a shared read lock
        FileChannel channel = FileChannel.open(path, StandardOpenOption.READ);
        FileLock readLock;
        System.out.println("File maybe in use. Please wait...");
        readLock = channel.lock(0, Long.MAX_VALUE, true);

        // read records from file and store in list of records an then close channel releasing lock
        readRecordsFromFile(channel);
        channel.close();
        
        // sorting list of student records based on Name
        Collections.sort(studData, (r1, r2) -> r1.Name.compareTo(r2.Name));

        // create file if it doesn't exist
        File newFile = new File("Sorted_Name.txt");
        newFile.createNewFile();

        // open channel to with append to append each record one by one 
        channel = FileChannel.open(Paths.get("Sorted_Name.txt"), StandardOpenOption.APPEND);

        // Adding headers in file
        String headerData = String.format("%-20s", "Roll No.") + 
                            String.format("%-20s", "Name") + 
                            String.format("%-20s", "MailID") + 
                            String.format("%-20s", "Marks") + "\n";

        ByteBuffer buf = ByteBuffer.wrap(headerData.getBytes()); 

        // erasing file
        channel.truncate(0);
        channel.write(buf);

        // iterate over each record and write in the file 
        for (Record record : studData) {
            String recordData = String.format("%-20s", Integer.toString(record.RollNo)) + 
                                String.format("%-20s", record.Name) + 
                                String.format("%-20s", record.MailID) + 
                                String.format("%-20s", Integer.toString(record.Marks)) + "\n";
            
            buf = ByteBuffer.wrap(recordData.getBytes()); 
            channel.write(buf);
        }

        // close channel releasing the lock
        channel.close();
        System.out.println("Sorted_Name.txt successfully generated.");
    }

}