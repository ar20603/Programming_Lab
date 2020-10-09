import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Scanner;
import java.util.function.ToLongFunction;
import java.util.concurrent.TimeUnit;

// class for a sock
class Sock {

    // member variable for storing color
    private String color;

    Sock(String color) {
        this.color = color;
    }

    public String getColor() {
        return color;
    }

}

// class for robotic arms
// It extends 'Thread' allowing it to run on a new thread
class RoboticArm extends Thread {

    // to indicate the ID/identity of robotic arm
    private int index;

    // list of socks from the heap alloted to the arm
    private List<Sock> socks;

    // the Matching machine it passes the sock to
    private MatchingMachine matchingMachine;

    // constructor for robotic arm
    RoboticArm(int index, List<Sock> socks, MatchingMachine matchingMachine) {
        this.index = index;
        this.socks = socks;
        this.matchingMachine = matchingMachine;
    }

    // function called when thread/machine is started
    public void run() {
        System.out.println("Robotic Arm " + index + " is running...");
        pickSockandPass();
    }

    // pick sock one by one from the list of socks alloted to that arm and pass
    private void pickSockandPass() {
        for (Sock sock : socks) {
            passToMatchingMachine(sock);
        }
    }

    // pass sock to matching machine
    private void passToMatchingMachine(Sock sock) {
        System.out.println("Robotic Arm " + index + ": Sending " + sock.getColor() + " color sock to Matching machine.");
        matchingMachine.getSock(sock);

        // sleep robotic arm showing the time it takes to pass to matching machine 
        // before picking its next sock
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            System.err.println(e);
        }
        
    }
}

// class for Matching Machine
// It extends 'Thread' allowing it to run on a new thread
class MatchingMachine extends Thread {

    // the ShelfManager it passes the socks pair to
    private ShelfManager shelfManager;

    // to store lists of all socks currently in machine
    // different list for diffenrent color
    private HashMap<String, ArrayList<Sock>> socksMap;

    // lsit of colors
    public static List <String> colors = new ArrayList<>(
        Arrays.asList("white", "blue", "black", "grey")
    );

    // variables to stop the machine when job is done
    private int pairsSentAhead;
    private int totalMatchPossible;

    // constructor for Matching Machine
    MatchingMachine(ShelfManager shelfManager, int totalMatchPossible) {
        this.socksMap = new HashMap<>();
        this.shelfManager = shelfManager;
        this.pairsSentAhead = 0;
        this.totalMatchPossible = totalMatchPossible;
    }

    // function called when thread/machine is started
    public void run() {
        System.out.println("Matchmaking machine is running...");

        // unless job is done, it checks for matches
        while(pairsSentAhead < totalMatchPossible) {
            checkForMatch();
        }
    }

    // to check for matches in list of each color
    public synchronized void checkForMatch() {
        for (String color : colors) {
            if(socksMap.containsKey(color)) {
                int count = socksMap.get(color).size();

                // if a pair of same coloured socks is available
                if(count >= 2) {
                    Sock sock1 = socksMap.get(color).get(0);
                    Sock sock2 = socksMap.get(color).get(1);
                    socksMap.get(color).remove(1);
                    socksMap.get(color).remove(0);

                    // sending it to shelf manager machine
                    passPairToShelfManager(sock1, sock2);
                }
            }
        }
    }

    // to receive sock from robotic arms
    public synchronized void getSock(Sock sock) {
        String color = sock.getColor();     
        
        // add sock to the list int the machine corresponding to its color
        if(!socksMap.containsKey(color)) {
            socksMap.put(color, new ArrayList<>());
        }
        
        socksMap.get(color).add(sock);
        System.out.println("Matching Machine: Received a " + sock.getColor() + " sock.");
    }

    // to pass a sock pair to Shelf manager
    private void passPairToShelfManager(Sock sock1, Sock sock2) {
        System.out.println("Matching Machine: Sending " + sock1.getColor() + " pair of socks to Shelf Manager.");
        shelfManager.getSocksPair(sock1, sock2);
        pairsSentAhead++;
    }

}

// class for Shelf manager machine
// It extends 'Thread' allowing it to run on a new thread
class ShelfManager extends Thread {

    // Queue to store pair of socks in the machine currently
    private Queue <String> pairQueue;

    // variables to stop the machine when job is done
    private int pairsPutToShelf;
    private int totalMatchPossible;

    // constructor for shlf manager machine
    ShelfManager(int totalMatchPossible) {
        this.pairQueue = new LinkedList<>();
        this.pairsPutToShelf = 0;
        this.totalMatchPossible = totalMatchPossible;
    }

    // function called when thread/machine is started
    public void run() {
        System.out.println("Shelf Manager Robot is running...");

        // unless job is done, it checks for matches
        while(pairsPutToShelf < totalMatchPossible) {
            putToShelf();
        }

    }

    // if the current queue of sock pairs is non-empty
    // it takes one and puts tot he shelf
	private synchronized void putToShelf() {
        if(!pairQueue.isEmpty()) {
            System.out.println("Shelf Manager: A pair of " + pairQueue.remove() + " socks put to the appropriate shelf."); 
            pairsPutToShelf++;
        }
    }

    // to receive sock pair from matching machine
    public synchronized void getSocksPair(Sock sock1, Sock sock2) {
        pairQueue.add(sock1.getColor());
        System.out.println("Shelf Manager: Received a " + sock1.getColor() + " pair of socks.");
    }

}

// main class for Sock Matching process
public class SockMatching {

    // list of socks and robotic arms 
    public static List<Sock> allSocks = new ArrayList<>();
    public static List<RoboticArm> roboticArms = new ArrayList<>();
    public static ShelfManager shelfManager;
    public static MatchingMachine matchingMachine;

    // list of colors
    public static List <String> colors = new ArrayList<>(
        Arrays.asList("white", "blue", "black", "grey")
    );

    // variable to store count of all possible pairs to stop all machines 
    static int totalMatchPossible = 0;

    // main function
    public static void main(String args[]) throws FileNotFoundException {

        // Take number of robotic arms as input
        System.out.print("Input number of Robotics Arms: ");
        Scanner sc = new Scanner(System.in);
        int numArms = sc.nextInt();

        // scan file and create list of socks
        Scanner fp = new Scanner(new File("socks.txt"));
        while (fp.hasNextLine()) {
            String color = fp.next();
            if (!color.isEmpty()) {
                allSocks.add(new Sock(color));
            }
        }
        fp.close();

        System.out.println("Initially, " + allSocks.size() + " socks in the heap.");

        // to calculate count of all possible pairs that can be put to shelf
        HashMap<String, Integer> count = new HashMap<>();
        for (Sock sock : allSocks) {
            String color = sock.getColor();
            if (!count.containsKey(color)) {
                count.put(color, 1);
            } else {
                count.replace(color, count.get(color) + 1);
            }
        }

        for (String color : colors) {
            if (count.containsKey(color)) {
                totalMatchPossible += ((count.get(color)) / 2);
            }
        }
        
        // initializing shelf manager and matching machine
        shelfManager = new ShelfManager(totalMatchPossible);
        matchingMachine = new MatchingMachine(shelfManager, totalMatchPossible);

        // starting other machines (in different threads)
        shelfManager.start();
        matchingMachine.start();

        int socksLeft = allSocks.size();
        int armsLeft = numArms;
        int socksAlloted = 0;

        // alloting a small part of heap of socks to each thread
        // to ensure better parallelism 
        for (int i = 0; i < numArms; i++) {
            int countToAllot = (int) Math.ceil((float)socksLeft / armsLeft);
            List<Sock> listToAllot = allSocks.subList(socksAlloted, socksAlloted + countToAllot);
            roboticArms.add(new RoboticArm(i, listToAllot, matchingMachine));
                           
            armsLeft -= 1;
            socksLeft -= countToAllot;
            socksAlloted += countToAllot;
        }
        
        // starting all robotic arms (in different threads)
        for (int i = 0; i < numArms; i++) {
            roboticArms.get(i).start();
        }

        sc.close();
    }
}