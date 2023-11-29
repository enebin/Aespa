import os
import re

def extract_code_snippets(directory):
    snippets = {}

    start_tag_prefix = '// EXAMPLE_CODE:'
    end_tag = '// EXAMPLE_CODE: END'
    start_tag_pattern = re.compile(rf"{re.escape(start_tag_prefix)}\s*(\w+)")

    current_identifier = None
    current_snippet = []

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.swift'):
                with open(os.path.join(root, file), 'r') as f:
                    for line in f:
                        if current_identifier:
                            if end_tag in line:
                                formatted_snippet = format_snippet(current_snippet)
                                snippets[current_identifier] = formatted_snippet
                                current_identifier = None
                                current_snippet = []
                            else:
                                current_snippet.append(line)
                        else:
                            start_tag_match = start_tag_pattern.search(line)
                            if start_tag_match:
                                current_identifier = start_tag_match.group(1)

    return snippets

def format_snippet(snippet):
    # Determine the indentation of the first line
    first_line_indent = len(snippet[0]) - len(snippet[0].lstrip())

    formatted_lines = []
    previous_line_was_empty = True  # Start assuming the previous line was empty

    for line in snippet:
        # Remove the common indentation
        line_content = line[first_line_indent:] if len(line) > first_line_indent else line

        # Check if the line is empty after removing indentation
        if line_content.strip():
            formatted_lines.append(line_content.rstrip())
            previous_line_was_empty = False
        elif not previous_line_was_empty:
            # Add an empty line only if the previous line was not empty
            formatted_lines.append('')
            previous_line_was_empty = True

    # Join the lines and strip leading/trailing whitespace
    return '\n'.join(formatted_lines).strip()

def update_readme(readme_path, code_snippets):
    with open(readme_path, 'r') as file:
        readme_content = file.read()

    for identifier, snippet in code_snippets.items():
        # Define the start and end tags
        start_tag = f"<!-- INSERT_CODE: {identifier} -->"
        end_tag = "<!-- INSERT_CODE: END -->"

        # Check for the presence of the start tag
        if readme_content.count(start_tag) != 1:
            raise ValueError(f"Error: Start tag for '{identifier}' not found or duplicated")

        pattern = re.compile(rf"({re.escape(start_tag)}).*?({re.escape(end_tag)})", re.DOTALL)

        # Verify that each start tag is followed by an end tag
        if not pattern.search(readme_content):
            raise ValueError(f"Error: End tag not found following the start tag for '{identifier}'")
        
        # Replace the content in the README
        replacement = rf"\1\n```swift\n{snippet}\n```\n\2"
        readme_content = pattern.sub(replacement, readme_content)

    with open(readme_path, 'w') as file:
        file.write(readme_content)


# Example usage
root_folder = '../'
snippets = extract_code_snippets(root_folder + 'Tests/ExampleCode')
update_readme(root_folder + 'README.md', snippets)