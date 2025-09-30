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

def extract_topics_from_heading(heading):
    """Extract topics from heading based on keywords."""
    topics_map = {
        'Linux': ['Linux', 'User', 'SSH', 'Shell', 'Server', 'Administration'],
        'Docker': ['Docker', 'Container', 'Image', 'Kubernetes'],
        'Kubernetes': ['Kubernetes', 'Pod', 'Orchestration', 'Deployment', 'Deploy', 'Service', 'Cluster', 'Docker'],
        'Git': ['Git', 'Repository', 'Branch', 'Merge', 'Clone', 'Fork'],
        'Database': ['Database', 'MySQL', 'PostgreSQL', 'MariaDB', 'Redis'],
        'Networking': ['Network', 'Port', 'Load Balancer', 'SSL', 'Nginx'],
        'Ansible': ['Ansible', 'Automation'],
        'IaC': ['Terraform', 'IaC', 'Infrastructure as Code', 'Pulumi', 'CloudFormation'],
        'CI/CD': ['CI/CD', 'Continuous Integration', 'Continuous Deployment', 'Jenkins', 'Travis CI', 'CircleCI', 'GitHub Actions', 'GitLab CI', 'Azure Pipelines', 'Drone', 'TeamCity', 'Bamboo', 'Jenkins', 'GitLab CI', 'Azure Pipelines', 'Drone', 'TeamCity', 'Bamboo', 'ArgoCD', 'Argo Rollouts', 'Argo Events', 'Argo Workflows', 'Argo CD', 'Argo Rollouts', 'Argo Events', 'Argo Workflows', 'ArgoCD', 'Argo Rollouts', 'Argo Events', 'Argo Workflows'],
        'Monitoring': ['prometheous', 'grafana', 'loki'],
        'Security': ['Security', 'SSL', 'SSH', 'Root Access']
    }
    
    heading_lower = heading.lower()
    matched_topics = []
    
    for topic, keywords in topics_map.items():
        if any(keyword.lower() in heading_lower for keyword in keywords):
            matched_topics.append(topic.title())
    
    return ', '.join(matched_topics) if matched_topics else 'General'

def update_progress(progress):
    """Update the progress in the README.md"""
    with open('README.md', 'r', encoding='utf-8') as file:
        content = file.read()
    
    # Find and replace the progress line
    pattern = r'!\[\d+%\]\(https://progress-bar\.xyz/\d+\)'
    replacement = f'![{progress}%](https://progress-bar.xyz/{progress})'
    updated_content = re.sub(pattern, replacement, content)
    
    with open('README.md', 'w', encoding='utf-8') as file:
        file.write(updated_content)

def update_daily_challenge(new_challenge, day_number):
    """Update the README.md with new daily challenge file in the days directory."""
    with open('README.md', 'r', encoding='utf-8') as file:
        content = file.read()

    # Check if this day already exists in the table
    if f"| {day_number} |" in content:
        print(f"Day {day_number} already exists in README.md")
        return

    # Find the position just before "## Prerequisites"
    prerequisites_pos = content.find('## Prerequisites')
    if prerequisites_pos == -1:
        prerequisites_pos = content.find('## Prerequisites')
    
    if prerequisites_pos != -1:
        # Insert the new challenge before Prerequisites section
        updated_content = content[:prerequisites_pos-1] + new_challenge + '\n' + content[prerequisites_pos:]
        
        with open('README.md', 'w', encoding='utf-8') as file:
            file.write(updated_content)
        print(f"Added new challenge entry for day {day_number}")
    else:
        print("Could not find Prerequisites section to insert challenge")


def update_readme():
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
    heading = extract_main_heading(md_files[-1])
    link = f"[Solution](./days/{md_files[-1].name})"
    day_number = extract_day_number(md_files[-1].name)
    topics = extract_topics_from_heading(heading)
    new_challenge = f"| {day_number} | {heading} | {topics} | {link} |\n"

    update_progress(day_number)
    update_daily_challenge(new_challenge, day_number)

if __name__ == "__main__":
    # Check if we're in the right directory
    if not os.path.exists('days'):
        print("Error: 'days' directory not found. Please run this script from the project root.")
        exit(1)
    
    print("Updating days/README.md...")
    update_readme()
