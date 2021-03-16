# HadsAlood

A game written in VHDL, in which the user must guess the number generated randomly by the system.

## Cool Stuff?

You might be interested in running and testing this project. Aside from that, there may be other things you like to discover (e.g. in the implementation):

### Pseudo-Random Number Generator (PRNG)

At the time of development, using internal methods to generate random numbers was not permitted, and the PRNG must be implemented manually. `random_generator_n_bit` is the entity name implementing this functionality.

Although it may not distribute numbers very well, or producing really unpredictable results, the tests show it is reliable. Who knows, there might be an idea of a new good random generation algorithm living there.

You may have a hard time understanding the implementation, as it is somehow complex. The code comments should help you in this case. If you know Persian, there is an almost good report under `report-fa` branch, describing this part as well.

### Automation Scripts

For making the process of entity creation and testing in a standard way, there are two scripts inside `scripts/` directory. Both have usage guides (via `help` command). And, they are written in PHP, and require you to have both GHDL and GtkWave installed on your system.

## Building and Testing (I.e. Simulation)

Testing can be done either manually or automatically. It is prefered to do the tests using automation scripts, as described in the section above. For example, if you want to simulate the game itself, you can do:

```
./scripts/start-unit-test.php test_main build
```

All entities are well-tested, and for almost each entity, there is at least one test-bench available.

## License

VHDL source codes and the scripts are licensed under [GPLv3](./LICENSE.md).
