{
  imports = [
    ./env.nix
    ./home.nix
    ./mime-apps.nix
  ];

  users.users.narek = {
    isNormalUser = true;
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };
}
