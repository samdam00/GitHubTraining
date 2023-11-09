# MyCustomLibrary.py

class MyCustomLibrary:
    def __init__(self):
        self.counter = 0

    def increment_counter(self):
        self.counter += 1

    def get_counter_value(self):
        return self.counter

    def greet(self, name):
        return "Hello, {}!".format(name)