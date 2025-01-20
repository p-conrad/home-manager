.PHONY: update
update:
	home-manager switch --flake .#peter

.PHONY: clean
clean:
	nix-collect-garbage -d
