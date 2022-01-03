# HadsAlood

A game written in VHDL, in which the user must guess the number generated randomly by the system.

## Cool Stuff?

You might be interested in testing this project. Aside from that, there may be other things you like to discover (say, in the implementation):

### Pseudo-Random Number Generator (PRNG)

At the time of development, using internal methods to generate random numbers was not permitted, and the PRNG must be implemented manually. `random_generator_n_bit` is the entity name implementing this functionality.

Although it may not distribute numbers very well, or producing really unpredictable results, the tests show it is reliable. Who knows, there might be an idea of a good new random generation algorithm living there.

You may have a hard time understanding the implementation, as it is somehow complex. The code comments should help you in this case. If you know Persian, there is an almost good report under `report-fa` branch, describing this part as well.

### Automation Scripts

The project uses [Parvaj](https://github.com/machitgarha/parvaj) for making the process of entity creation and testing quicker and easier. In fact, Parvaj was born as a side-project of this project.

## Simulation and Testing

Prepare Parvaj (following the guide [here](https://github.com/machitgarha/parvaj#requirements)), and then simulate the whole game:

```
./scripts/bin/parvaj simulate test_main
```

Feel free to edit `tests/unit/main/test-main.vhd`, put your own guesses there, re-simulate the project, and see how the game works. Maybe this makes you curious to look into the implementation?

## License

Licensed under [GPLv3](./LICENSE.md).
