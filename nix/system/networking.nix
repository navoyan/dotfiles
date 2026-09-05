{pkgs, ...}: {
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

  networking.hostName = "nixos";
  networking.hosts = {
    "127.0.0.1" = [
      "minikube.localhost"
      "minikube.info"
      "api.minikube.info"
      "grafana.minikube.info"
    ];
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      Domains = ["~."];
      DNSOverTLS = "true";
      FallbackDNS = [
        "1.1.1.1"
        "1.0.0.1"
      ];
    };
  };

  services.netbird.enable = true;

  environment.systemPackages = with pkgs; [
    proton-vpn-cli
  ];
}
