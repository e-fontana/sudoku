def decode_color(bin_code: str) -> str:
    color_map = {
        '00': 'white',
        '01': 'yellow',
        '10': 'red'
    }
    return color_map.get(bin_code, 'unknown')


def parse_visibility(value: str):
    parts = [p.strip() for p in value.split('|')]

    # Part 1 – visibility states
    states_str = parts[0].split()[1]  # e.g., '1,0,1'
    states = [bool(int(x)) for x in states_str.split(',')]

    # Part 2 – colors (binary format)
    color_codes_str = parts[1].split()[1]  # e.g., '00,01,10'
    color_codes = color_codes_str.split(',')
    colors = [decode_color(code) for code in color_codes]

    # Combine visibility state and color
    visibility_data = [[state, color] for state, color in zip(states, colors)]

    # Part 3 – position
    position_parts = parts[2].split()
    position = [int(position_parts[1]), int(position_parts[2])]

    # Part 4 – strikes (errors)
    strikes = int(parts[3].split()[1])

    # Part 5 – selected number (only if yellow exists)
    selected_number = int(parts[4]) if 'yellow' in colors else None

    return visibility_data, position, strikes, selected_number