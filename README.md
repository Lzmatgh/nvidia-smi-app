# GPU Monitor

This project builds a Debian package that installs a small desktop launcher for:

```bash
watch -n 1 nvidia-smi
```

After installation, launch `GPU Monitor` from your desktop environment's app menu.
The launcher will open a terminal window and start the live NVIDIA GPU monitor.

## Build

```bash
./build-deb.sh
```

The resulting package will be written to `dist/`.

## Install

```bash
sudo apt install ./dist/gpu-monitor_0.1.0_all.deb
```

## Notes

- `watch` comes from the `procps` package.
- `nvidia-smi` is provided by the NVIDIA driver on the target machine.
- The launcher tries several common terminal emulators automatically.
- You can override the default terminal size with `GPU_MONITOR_TERMINAL_GEOMETRY`, for example `110x30` or `120x32`.
