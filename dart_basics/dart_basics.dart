
void main() {
  // 1. Variables and data types
  String studentName = 'Vamshi';
  int age = 20;
  double cgpa = 8.5;
  bool isLearningFlutter = true;

  print('--- Student Details ---');
  print('Name: $studentName');
  print('Age: $age');
  print('CGPA: $cgpa');
  print('Learning Flutter: $isLearningFlutter');

  // 2. Operators
  int firstNumber = 10;
  int secondNumber = 5;

  print('\n--- Arithmetic Operations ---');
  print('Addition: ${firstNumber + secondNumber}');
  print('Subtraction: ${firstNumber - secondNumber}');
  print('Multiplication: ${firstNumber * secondNumber}');
  print('Division: ${firstNumber / secondNumber}');

  // 3. Conditional statements
  print('\n--- Eligibility Check ---');
  if (age >= 18) {
    print('$studentName is an adult.');
  } else {
    print('$studentName is a minor.');
  }

  // 4. Loops
  print('\n--- For Loop ---');
  for (int i = 1; i <= 5; i++) {
    print('Number: $i');
  }

  // 5. Functions
  print('\n--- Function Example ---');
  print('Sum: ${addNumbers(10, 20)}');

  // 6. Lists
  List<String> skills = ['Dart', 'Flutter', 'Java'];
  print('\n--- Skills ---');
  for (final skill in skills) {
    print(skill);
  }
}

int addNumbers(int a, int b) {
  return a + b;
}
