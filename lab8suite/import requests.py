import requests

def decode_secret_message(doc_url):
    # Fetching data
    response = requests.get(doc_url)
    
    
    if response.status_code != 200:
        print("Error fetching document.")
        return
        
    
    # Spliting document
    
    lines = response.text.strip().split("\n")
    
    
    
    char_positions = [] # Parse character positions
    max_x, max_y = 0, 0
    
    for line in lines:
        parts = line.strip().split()
        if len(parts) != 3:
            continue 
            
        
        char, x, y = parts[0], int(parts[1]), int(parts[2])
        char_positions.append((char, x, y))
        
        
        # grid dimensions
        max_x = max(max_x, x) #x axe
        max_y = max(max_y, y) #y axe
    
    #create empty grid
    grid = [[" " for _ in range(max_x + 1)] for _ in range(max_y + 1)]
    
    # Filling the grid
    for char, x, y in char_positions:
        grid[y][x] = char  # Ensure y is the row index, x is the column index

    # printing row by row
    for row in grid:
        print("".join(row))


doc_url = """
decode_secret_message(doc_url)
