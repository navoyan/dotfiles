{pkgs, ...}: {
  networking.networkmanager.enable = true;
  networking.wireless.enable = true;

  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
  ];

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

  networking.hosts = {
    "127.0.0.1" = [
      "minikube.localhost"
      "minikube.info"
      "api.minikube.info"
      "grafana.minikube.info"
    ];
  };

  networking.firewall.allowedTCPPorts = [8900 8901 8902];

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  services.netbird = {
    enable = true;
    ui.enable = false;
  };

  environment.systemPackages = with pkgs; [
    bind
    inetutils

    proton-vpn-cli
  ];
}
