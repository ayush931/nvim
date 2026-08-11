# This is a sample Python file to test syntax highlights
import os

# Define a class for testing color scheme output
class ColorTest:
    def __init__(self, name):
        self.name = name  # Store the name parameter

    def display(self):
        # Print a greeting message to the console
        print(f"Hello, {self.name}!")

if __name__ == "__main__":
    # Instantiate the test class and invoke the display method
    test = ColorTest("Gemini")
    test.display()
