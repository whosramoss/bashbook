# shelldx

shelldx is a comprehensive collection of reusable Bash functions designed to enhance the command-line interface. This library provides a wide range of utilities for:

- Producing stylized and colored output
- Displaying interactive menus
- Running background processes with spinners
- Structured logging functions
- Supporting formatted tables

These tools enable developers to create more visually engaging and user-friendly scripts.

## Features

- **Stylized Output:** Easily produce colored and formatted text for better CLI readability.
- **Interactive Menus:** Create menus that allow user interaction in terminal scripts.
- **Background Processes with Spinners:** Run tasks in the background while displaying animated spinners.
- **Structured Logging:** Consistent and clear logging of script events and errors.
- **Formatted Tables:** Display data in organized, human-readable tables.

## Usage

### How to Run

Run the build script from root the project directory:

```bash
chmod +x ./scripts/start.sh && ./scripts/start.sh
```

This script will:

1. **Initializes the Project Interface**
   Loads the main library (`lib/main.sh`) and displays a stylized title (“shelldx”) followed by a section header introducing the project setup.

2. **Displays an Interactive Menu**
   Prompts the user to choose an option using arrow keys, showing categories like _Logs_, _Table_, _Checkbox_, _Step_, _Validations_, _Loading_, or _Build_.

3. **Links Menu Options to Example Scripts**
   Each menu item corresponds to a specific script file (e.g., `lib/logger/example.sh` or `scripts/build.sh`), allowing users to preview or execute functional examples for different ShellDX modules.

## Building the complete script file

To concatenate all `main.sh` files from each subfolder inside the `lib` directory into a single `shelldx.sh` file in the root project directory, run:

```bash
chmod +x ./scripts/build.sh && ./scripts/build.sh
```

This script builds the **`shelldx.sh` Library File**. and automatically generates a single consolidated file (`shelldx.sh`) by concatenating all `main.sh` files inside the `lib/` directory to keep the final file clean and executable

## Contributing

If you want to contribute to `shelldx`, please make sure to review the [contribution guidelines](https://github.com/whosramoss/shelldx/blob/master/CONTRIBUTING.md). This project makes use of [GitHub issues](https://github.com/whosramoss/shelldx/issues) for
tracking requests and bugs.

## License

MIT License. [LICENSE](./LICENSE)

## Author

Gabriel Ramos ([@whosramoss](https://github.com/whosramoss))
