import os

class ColorTest:
    def __init__(self, name):
        self.name = name

    def display(self):
        print(f"Hello, {self.name}!")

if __name__ == "__main__":
    test = ColorTest("Gemini")
    test.display()
