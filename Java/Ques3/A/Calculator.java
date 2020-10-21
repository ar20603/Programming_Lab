import javax.script.ScriptEngine;
import javax.script.ScriptEngineManager;
import javax.script.ScriptException;
import javax.swing.*;
import javax.swing.border.Border;

import java.awt.*;
import java.awt.event.*;

// custom class for buttons
class CaclJButton extends JButton {
	CaclJButton(String text) {
		// setting properties of button
		this.setBackground(Color.LIGHT_GRAY);
		this.setFont(new Font("Courier New", Font.PLAIN, 20));
		this.setText(text);
		this.setFocusable(false);
	}
}

// Main class for Calculator
// It extends the JFrame and
// Added listeners for mouse click and key press
class Calculator extends JFrame implements ActionListener, KeyListener
{
	// required GUI components
	private static JPanel panel; private static JTextField textDisplay;
	private static JButton[] numButtons = new JButton[10];					// array of buttons for numbers (0-9)
	private static JButton[] funcButtons = new JButton[6];					// array of buttons for functions (+,-,*,/,Clear,=)

	// variables to keep track of highlighted/ active buttons
	private static int active_num_index = 0;
	private static int active_func_index = 0;

	// Constructor for Calculator
	Calculator() {

		// setting properties of JFrame
		super("Calculator for Differently Abled");
		this.setSize(410, 630);
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		this.setResizable(false);
		
		// panel added in tht JFrame
		panel = new JPanel();	
		panel.setBackground(Color.DARK_GRAY);
		panel.setLayout(null);

		// (x, y) - current coordinates to add components
		// x and y are changed to set location for adding new components
		int x = 0, y = 0;
		int button_width = 100;
		int button_height = 50;
		// constants for space
		int internal_space = 25;
		int side_space = 30;

		x += side_space; y += side_space;
		
		// display textbox at the top and set its properties
		textDisplay = new JTextField(16); 
		textDisplay.setBackground(Color.LIGHT_GRAY);
		textDisplay.setOpaque(true);
		textDisplay.setBounds(x, y, 350, 75);
		textDisplay.setFont(new Font("Courier New", Font.PLAIN, 20));
		textDisplay.addKeyListener(this);
		textDisplay.setEditable(false);	
		panel.add(textDisplay);

		// row 1 of buttons
		// display number key 7 and set its properties
		y += (75 + internal_space);
		numButtons[7] = new CaclJButton("7");
		numButtons[7].setBounds(x, y, button_width, button_height);
		numButtons[7].addActionListener(this);
		numButtons[7].addKeyListener(this);
		panel.add(numButtons[7]);
		
		// display number key 8 and set its properties
		x += (button_width + internal_space);
		numButtons[8] = new CaclJButton("8");
		numButtons[8].setBounds(x, y, button_width, button_height);
		numButtons[8].addActionListener(this);
		numButtons[8].addKeyListener(this);
		panel.add(numButtons[8]);

		// display number key 9 and set its properties
		x += (button_width + internal_space);
		numButtons[9] = new CaclJButton("9");
		numButtons[9].setBounds(x, y, button_width, button_height);
		numButtons[9].addActionListener(this);
		numButtons[9].addKeyListener(this);
		panel.add(numButtons[9]);


		// row 2 of buttons
		// display number key 4 and set its properties
		x = side_space;
		y += (button_height + internal_space);
		numButtons[4] = new CaclJButton("4");
		numButtons[4].setBounds(x, y, button_width, button_height);
		numButtons[4].addActionListener(this);
		numButtons[4].addKeyListener(this);
		panel.add(numButtons[4]);
		
		// display number key 5 and set its properties
		x += (button_width + internal_space);
		numButtons[5] = new CaclJButton("5");
		numButtons[5].setBounds(x, y, button_width, button_height);
		numButtons[5].addActionListener(this);
		numButtons[5].addKeyListener(this);
		panel.add(numButtons[5]);

		// display number key 6 and set its properties
		x += (button_width + internal_space);
		numButtons[6] = new CaclJButton("6");
		numButtons[6].setBounds(x, y, button_width, button_height);
		numButtons[6].addActionListener(this);
		numButtons[6].addKeyListener(this);
		panel.add(numButtons[6]);


		// row 3 of buttons
		// display number key 1 and set its properties
		x = side_space;
		y += (button_height + internal_space);
		numButtons[1] = new CaclJButton("1");
		numButtons[1].setBounds(x, y, button_width, button_height);
		numButtons[1].addActionListener(this);
		numButtons[1].addKeyListener(this);
		panel.add(numButtons[1]);
		
		// display number key 2 and set its properties
		x += (button_width + internal_space);
		numButtons[2] = new CaclJButton("2");
		numButtons[2].setBounds(x, y, button_width, button_height);
		numButtons[2].addActionListener(this);
		numButtons[2].addKeyListener(this);
		panel.add(numButtons[2]);

		// display number key 3 and set its properties
		x += (button_width + internal_space);
		numButtons[3] = new CaclJButton("3");
		numButtons[3].setBounds(x, y, button_width, button_height);
		numButtons[3].addActionListener(this);
		numButtons[3].addKeyListener(this);
		panel.add(numButtons[3]);

		
		// row 4 of buttons
		// display number key 0 and set its properties
		y += (button_height + internal_space);
		x = (button_width + internal_space + side_space);
		numButtons[0] = new CaclJButton("0");
		numButtons[0].setBounds(x, y, button_width, button_height);
		numButtons[0].addActionListener(this);
		numButtons[0].addKeyListener(this);
		panel.add(numButtons[0]);


		// row 5 of buttons
		// display function key + and set its properties
		y += (side_space + button_height);
		x = side_space;
		funcButtons[0] = new CaclJButton("+");
		funcButtons[0].setBounds(x, y, button_width, button_height);
		funcButtons[0].addActionListener(this);
		funcButtons[0].addKeyListener(this);
		panel.add(funcButtons[0]);

		// display function key - and set its properties
		x += (button_width + internal_space);
		funcButtons[1] = new CaclJButton("-");
		funcButtons[1].setBounds(x, y, button_width, button_height);
		funcButtons[1].addActionListener(this);
		funcButtons[1].addKeyListener(this);
		panel.add(funcButtons[1]);

		// display function key * and set its properties
		x += (button_width + internal_space);
		funcButtons[2] = new CaclJButton("*");
		funcButtons[2].setBounds(x, y, button_width, button_height);
		funcButtons[2].addActionListener(this);
		funcButtons[2].addKeyListener(this);
		panel.add(funcButtons[2]);


		// row 6 of buttons
		// display function key / and set its properties
		y += (side_space + button_height);
		x = side_space;
		funcButtons[3] = new CaclJButton("/");
		funcButtons[3].setBounds(x, y, button_width, button_height);
		funcButtons[3].addActionListener(this);
		funcButtons[3].addKeyListener(this);
		panel.add(funcButtons[3]);

		// display function key 'Clear' and set its properties
		x += (button_width + internal_space);
		funcButtons[4] = new CaclJButton("Clear");
		funcButtons[4].setBounds(x, y, button_width, button_height);
		funcButtons[4].addActionListener(this);
		funcButtons[4].addKeyListener(this);
		panel.add(funcButtons[4]);		

		// display function key = and set its properties
		x += (button_width + internal_space);
		funcButtons[5] = new CaclJButton("=");
		funcButtons[5].setBounds(x, y, button_width, button_height);
		funcButtons[5].addActionListener(this);
		funcButtons[5].addKeyListener(this);
		panel.add(funcButtons[5]);

		// add the panel to the frame
		this.add(panel);
		
	}
	
	// called when a mouse click event occurs
	@Override
	public void actionPerformed(ActionEvent ae)
	{
		// get the text on the button triggering the event
		String btnText = ae.getActionCommand();

		// appending the clicked button text to the textbox display at the top
		if(btnText.equals("1")) {
			textDisplay.setText(textDisplay.getText() + numButtons[1].getText());
		}
		else if(btnText.equals("2")) {
			textDisplay.setText(textDisplay.getText() + numButtons[2].getText());
		}
		else if(btnText.equals("3")) {
			textDisplay.setText(textDisplay.getText() + numButtons[3].getText());
		}
		else if(btnText.equals("4")) {
			textDisplay.setText(textDisplay.getText() + numButtons[4].getText());
		}
		else if(btnText.equals("5")) {
			textDisplay.setText(textDisplay.getText() + numButtons[5].getText());
		}
		else if(btnText.equals("6")) {
			textDisplay.setText(textDisplay.getText() + numButtons[6].getText());
		}
		else if(btnText.equals("7")) {
			textDisplay.setText(textDisplay.getText() + numButtons[7].getText());
		}
		else if(btnText.equals("8")) {
			textDisplay.setText(textDisplay.getText() + numButtons[8].getText());
		}
		else if(btnText.equals("9")) {
			textDisplay.setText(textDisplay.getText() + numButtons[9].getText());
		}
		else if(btnText.equals("0")) {
			textDisplay.setText(textDisplay.getText() + numButtons[0].getText());
		}
		else if(btnText.equals("+")) {
			textDisplay.setText(textDisplay.getText() + funcButtons[0].getText());
		}
		else if(btnText.equals("-")) {
			textDisplay.setText(textDisplay.getText() + funcButtons[1].getText());
		}
		else if(btnText.equals("*")) {
			textDisplay.setText(textDisplay.getText() + funcButtons[2].getText());
		}
		else if(btnText.equals("/")) {
			textDisplay.setText(textDisplay.getText() + funcButtons[3].getText());
		}
		else if(btnText.equals("Clear")) {
			// clearing the text in the textbox display
			textDisplay.setText("");
		}
		else if(btnText.equals("=")) {
			try {
				// evaluating the string in the textbox and displaying the result there
				ScriptEngineManager manager = new ScriptEngineManager();
				ScriptEngine engine = manager.getEngineByName("js");
				String expression = textDisplay.getText();
				Object result = engine.eval(expression);
				textDisplay.setText(result.toString());
			} catch (Exception e) {
				// displaying error message for wrong input
				textDisplay.setText("Input error. Try again!");
			}
		}

    }
	
	// called when a key press event occurs
	@Override
	public void keyPressed(KeyEvent ke) {

		// if the key pressed is 'Space'
		if(ke.getKeyCode() == KeyEvent.VK_SPACE) {

			// if active function key is 'Clear', clear the textbox
			if(funcButtons[active_func_index].getText().equals("Clear")) {
				textDisplay.setText("");
			}
			else if(funcButtons[active_func_index].getText().equals("=")) {

				// if active function key is '=', evaluate and print result in the textbox
				try {
					ScriptEngineManager manager = new ScriptEngineManager();
					ScriptEngine engine = manager.getEngineByName("js");
					String expression = textDisplay.getText();
					Object result = engine.eval(expression);
					textDisplay.setText(result.toString());
				} catch (Exception e) {
					textDisplay.setText("Syntax error. Try again!");
				}
			}
			else {
				// for other function key, just append in the textbox
				textDisplay.setText(textDisplay.getText() + funcButtons[active_func_index].getText());
			}
		}

		// if the key pressed is 'Enter'
		if(ke.getKeyCode() == KeyEvent.VK_ENTER) {
			textDisplay.setText(textDisplay.getText() + numButtons[active_num_index].getText());
		}
	}

	@Override
	public void keyReleased(KeyEvent arg0) {
	}

	@Override
	public void keyTyped(KeyEvent arg0) {
	}

	// Main function 
	public static void main(String[] args) {

		// Initializing the calculator and making the frame visible
		Calculator cal = new Calculator();
		cal.setVisible(true);

		// colouring the initial active keys
		numButtons[active_num_index].setBackground(Color.CYAN);
		funcButtons[active_func_index].setBackground(Color.CYAN);


		// Listener to be called at regular intervals to change the active keys (both number and function keys)
		ActionListener changeActiveButton = new ActionListener() {

            public void actionPerformed(ActionEvent ae) {

				// update the current active number key and ajust background color
				numButtons[active_num_index].setBackground(Color.LIGHT_GRAY);
				active_num_index += 1;
				active_num_index %= numButtons.length;
				numButtons[active_num_index].setBackground(Color.CYAN);

				// update the current active function key and ajust background color
				funcButtons[active_func_index].setBackground(Color.LIGHT_GRAY);
				active_func_index += 1;
				active_func_index %= funcButtons.length;
				funcButtons[active_func_index].setBackground(Color.CYAN);
			}
			
		};

		// Timer used to call the listener which changes active keys
		Timer timer = new Timer(1500, changeActiveButton);
        timer.start();
	}
	
}