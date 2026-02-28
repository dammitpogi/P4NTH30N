import re
import glob

for file in glob.glob('chapter-*.html'):
    with open(file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Remove the Lessons (Source Material) section
    pattern = r'<h2>Lessons \(Source Material\)</h2>.*?</div>\s*</div>\s*(<div class="chapter-nav">)'
    content = re.sub(pattern, r'\1', content, flags=re.DOTALL)

    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f'Processed: {file}')
