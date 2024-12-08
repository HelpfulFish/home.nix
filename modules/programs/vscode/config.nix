{
  settings = {
    "json.schemaDownload.enable" = true;
    "telemetry.telemetryLevel" = "off";
    "gitlens.telemetry.enabled" = false;
    "editor.fontFamily" = "'Fira Code', 'Fira Mono', monospace";
    "editor.fontLigatures" = true;
    "files.exclude" = {
      "**/node_modules" = true;
    };
    "editor.minimap.maxColumn" = 120;
    "editor.minimap.scale" = 1;
    "workbench.colorTheme" = "Default Dark Modern";
    "editor.cursorBlinking" = "blink";
    "editor.cursorWidth" = 100;
    "terminal.integrated.shellIntegration.enabled" = true;
    "explorer.confirmDragAndDrop" = false;
    "explorer.confirmDelete" = false;
    "[typescriptreact]" = {
    "editor.defaultFormatter" = "esbenp.prettier-vscode";
    };
    "[json]" = {
    "editor.defaultFormatter" = "vscode.json-language-features";
    };
    "vim.handleKeys" = {
      "<C-p>" = false; # ctrl+p use vscode default to find file
      "<C-c>" = false; # ctrl+c use system default to copy
      "<C-a>" = false; # ctrl+a use system default to copy all text
    };
    "vim.leader" = "<space>";
    "vim.normalModeKeyBindings" = [
      {
        # find file: SPC-f-f
        "before" = ["<leader>" "f" "f"];
        "commands" = [
          "workbench.action.quickOpen"
        ];
      }
    ];
  };
}
