from os import listdir
import json
from os.path import join
from pathlib import Path

FROM_DIR = 'cards'

CARD_KEY_SQL_FORMAT = "INSERT INTO card_keys (id, eng_name) VALUES ('cw_{}', '{}') ON CONFLICT DO NOTHING;"
CARD_SQL_FORMAT = "INSERT INTO cards (card_key_id, name, text, image_url, price, in_stock_amount, poster_id, card_type_id, language_id, expansion_id) VALUES ('cw_{}', '{}', '{}', '{}', 0, 0, 1, 'CW', 'EN', 'cw1') ON CONFLICT DO NOTHING;"

IMAGE_MAP = {}
image_data = json.loads(open('image_data.json', 'r').read())
for d in image_data:
    IMAGE_MAP[Path(d['name']).stem] = d['url']

RESULT = '''
insert into card_types (id, long_name, short_name) values ('CW', 'Card Wars', 'cardwars');
insert into languages (id, long_name) values ('EN', 'English');
INSERT INTO expansions (id, short_name, full_name) VALUES ('cw1', 'CW1', 'Card Wars') ON CONFLICT DO NOTHING;

'''

for file in listdir(FROM_DIR):
    data = json.loads(open(join(FROM_DIR, file), 'r').read())

    n = data['Name']
    name = data['Name'].replace('\'', '\'\'')
    if not n in IMAGE_MAP:
        print('No image for card', n)
        continue
    key = name.lower().replace('\'', '').replace(' ', '_')
    text = data['Text'].replace('\'', '\'\'')
    RESULT += CARD_KEY_SQL_FORMAT.format(key, name) + '\n'
    RESULT += CARD_SQL_FORMAT.format(key, name, text, IMAGE_MAP[n]) + '\n\n'

open('fill.sql', 'w').write(RESULT)


