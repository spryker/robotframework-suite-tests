def get_url_without_starting_slash(string):
    if string[0] == "/":
        string_without_starting_slash = string[1:]
        return string_without_starting_slash
    else:
        return string
