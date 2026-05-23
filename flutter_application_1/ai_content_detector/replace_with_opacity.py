import re
from pathlib import Path

pattern = re.compile(r'([A-Za-z0-9_.]+)\.withOpacity\(([^)]+)\)')

files = [
    Path('lib/themes/widgets/glow_card.dart'),
    Path('lib/themes/widgets/particle_field.dart'),
    Path('lib/themes/widgets/screens/about_screen.dart'),
    Path('lib/themes/widgets/screens/home_screen.dart'),
    Path('lib/themes/widgets/screens/result_screen.dart'),
]

for path in files:
    text = path.read_text(encoding='utf-8')
    new_text = pattern.sub(lambda m: f"{m.group(1)}.withAlpha(({m.group(1)}.alpha * {m.group(2)}).round())", text)
    if new_text != text:
        path.write_text(new_text, encoding='utf-8')
        print(f'Updated {path}')
