{ config, lib, pkgs, ...}:

let
  cfg = config.services.tiny-dfr;
  tiny-dfr-pkg = import ./default.nix { inherit pkgs; };
  cfgFile = "${cfg.package}/share/tiny-dfr/config.json";
in
{
  options.services.tiny-dfr = {
    enable = lib.mkEnableOption "Enable tiny-dfr on login";
    package = lib.mkOption {
      type = lib.types.package;
      default = tiny-dfr-pkg;
      description = "The package to use";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    services.udev.packages = [ cfg.package ];

    # environment.etc."tiny-dfr/config.json".source = cfgFile;
    # systemd.services.tiny-dfr.restartTriggers = [ cfgFile ];
    systemd.services.tiny-dfr.wantedBy = [ "multi-user.target"];
  };
}
