{
  imports = [
    ./env.nix
    ./home.nix
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
