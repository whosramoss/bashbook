<h1>
  <p align="center">
    <img src="./icon.png" alt="logo" width="128">
     <br>bashbook
  </p>
</h1>

<p align="center">
 A Bash toolkit for building polished CLI scripts.
  <br /> <br />
    <a href="#getting-started">Getting started</a>
    ·
    <a href="#system-scripts">System scripts</a>
</p>

## Getting started

Source the library from your script (adjust the path as needed):

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/bashbook/commands.sh"
```

Run the demo to see most helpers in action:

```bash
cd bashbook
bash ./test.sh
```

On Linux, make scripts executable first: `chmod +x test.sh`.

## System scripts

Standalone scripts that print machine information to the terminal. They all source `commands.sh` and work on **Linux** and **Windows** (via PowerShell where needed).

| Script               | What it shows                                                |
| -------------------- | ------------------------------------------------------------ |
| `1_cpu_ram_gpu.sh`   | CPU, RAM, and GPU details                                    |
| `2_storage.sh`       | Disks, partitions, and space                                 |
| `3_os_user.sh`       | OS version, user, hostname, hardware IDs, license hints      |
| `4_network.sh`       | Local/public IP, gateway, MAC, Wi-Fi, DNS                    |
| `5_system_health.sh` | Uptime, CPU/RAM usage, top processes, startup items, updates |
| `main.sh`            | Runs all of the above in sequence                            |

Run one script from the `system/` folder:

```bash
cd system
chmod +x *.sh   # Linux only
bash ./1_cpu_ram_gpu.sh
```

Or run everything:

```bash
cd system
bash ./main.sh
```

Some Linux features (for example `dmidecode`, `nvidia-smi`) depend on optional tools being installed; the scripts degrade gracefully when they are missing.

## License

MIT License. [LICENSE](./LICENSE)

## Author

Gabriel Ramos de Paula ([@whosramoss](https://github.com/whosramoss))
