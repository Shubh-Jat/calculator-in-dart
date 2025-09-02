import 'dart:io';

/// Performs a basic arithmetic calculation based on the input expression.
///
/// The expression should be in the format "number operator number" (e.g., "5 + 3").
/// Supported operators are '+', '-', '*', '/'.
///
/// Returns a [String] representing the result of the calculation or an error message.
String _calculate(String expression) {
  expression = expression.trim();

  // Define allowed operators
  const List<String> operators = ['+', '-', '*', '/'];

  String? operator;
  List<String> operands = [];

  // Find the operator and split the expression
  // This logic assumes a single operator in the expression.
  for (String op in operators) {
    final int opIndex = expression.indexOf(op);
    if (opIndex != -1) {
      final int lastOpIndex = expression.lastIndexOf(op);

      // If the operator appears more than once, it's an invalid format for this simple calculator.
      if (opIndex != lastOpIndex) {
        return 'Error: Multiple operators or invalid format. Please use one operator (e.g., "5 + 3").';
      }

      operator = op;
      // Split by the operator, ensuring it's not part of a number (e.g., "1.0e+5")
      // For simple single operator, split works. For complex parsing, a regex or parser library would be better.
      operands = expression.split(RegExp(r'\s*' + RegExp.escape(op) + r'\s*'));
      break; // Found operator, exit loop
    }
  }

  // Check if an operator was found and if there are exactly two operands
  if (operator == null || operands.length != 2) {
    return 'Error: Invalid expression format. Please use two numbers and one operator (e.g., "5 + 3").';
  }

  String operand1String = operands[0].trim();
  String operand2String = operands[1].trim();

  // Parse operands to double
  double? num1 = double.tryParse(operand1String);
  double? num2 = double.tryParse(operand2String);

  if (num1 == null || num2 == null) {
    return 'Error: Invalid number format. Please ensure both operands are valid numbers.';
  }

  double result;
  switch (operator) {
    case '+':
      result = num1 + num2;
      break;
    case '-':
      result = num1 - num2;
      break;
    case '*':
      result = num1 * num2;
      break;
    case '/':
      if (num2 == 0) {
        return 'Error: Division by zero is not allowed.';
      }
      result = num1 / num2;
      break;
    default:
      // This case should ideally not be reached if operator is checked above,
      // but included for robustness.
      return 'Error: Unknown operator "$operator".';
  }

  // Format the result to avoid excessive decimal places for whole numbers
  if (result == result.toInt()) {
    return result.toInt().toString();
  }
  return result.toString();
}

void main() {
  print('Simple Command-Line Calculator');
  print('Enter an expression (e.g., "5 + 3") or type "exit" to quit.');

  while (true) {
    stdout.write('> '); // Prompt for user input
    String? input = stdin.readLineSync(); // Read a line of input from the console

    // Handle null input (e.g., EOF) or 'exit' command
    if (input == null || input.toLowerCase() == 'exit') {
      print('Exiting calculator.');
      break; // Exit the loop and terminate the program
    }

    // Skip empty input
    if (input.trim().isEmpty) {
      continue;
    }

    // Calculate the result and print it
    String result = _calculate(input);
    print('Result: $result');
  }
}
