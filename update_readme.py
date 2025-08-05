#!/usr/bin/env python3
"""
Script to automatically update days/README.md based on .md files in the days directory.
Extracts the main heading from each .md file and creates a table entry.
"""

import os
import re
import glob
from pathlib import Path

def extract_main_heading(file_path):
    """Extract the main heading (first # heading) from a markdown file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            for line in file:
                line = line.strip()
                if line.startswith('# '):
                    # Remove the '# ' prefix and return the heading
                    return line[2:].strip()
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return None
    return None

def extract_day_number(filename):
    """Extract day number from filename (e.g., '001.md' -> '001')."""
    return os.path.splitext(filename)[0]

def generate_readme_content():
    """Generate the complete README.md content."""
    # Get the days directory path
    days_dir = Path('days')
    
    # Find all .md files except README.md
    md_files = []
    for file_path in days_dir.glob('*.md'):
        if file_path.name != 'README.md':
            md_files.append(file_path)
    
    # Sort files by filename (this will sort 001.md, 002.md, etc. correctly)
    md_files.sort(key=lambda x: x.name)
    
    # Start building the README content
    readme_content = "# Daily Dose of KodeKloud\n\n"
    readme_content += "|Days|Task|Solved|\n"
    readme_content += "|---|---|---|\n"
    
    # Process each file
    for file_path in md_files:
        day_number = extract_day_number(file_path.name)
        heading = extract_main_heading(file_path)
        
        if heading:
            # Create the table row
            link = f"[Link](./{file_path.name})"
            readme_content += f"| {day_number} | {heading} | [x] {link} |\n"
        else:
            print(f"Warning: Could not extract heading from {file_path}")
    
    return readme_content

def update_readme():
    """Update the README.md file in the days directory."""
    readme_path = Path('days/README.md')
    
    try:
        # Generate new content
        new_content = generate_readme_content()
        
        # Write to README.md
        with open(readme_path, 'w', encoding='utf-8') as file:
            file.write(new_content)
        
        print(f"Successfully updated {readme_path}")
        print("\nGenerated content:")
        print("-" * 50)
        print(new_content)
        
    except Exception as e:
        print(f"Error updating README.md: {e}")

if __name__ == "__main__":
    # Check if we're in the right directory
    if not os.path.exists('days'):
        print("Error: 'days' directory not found. Please run this script from the project root.")
        exit(1)
    
    print("Updating days/README.md...")
    update_readme()