# Content

- [ROHD Interfaces](#rohd-interfaces)

## Learning Outcome

## ROHD Interfaces

Interfaces make it easier to define port connections of a module in a reusable way. An example of the counter re-implemented using interfaces is shown below.

`Interface` takes a generic parameter for direction type. This enables you to group signals so make adding them as inputs/outputs easier for different modules sharing this interface.

The `Port` class extends `Logic`, but has a constructor that takes width as a positional argument to make interface port definitions a little cleaner.

When connecting an `Interface` to a `Module`, you should always create a new instance of the `Interface` so you don't modify the one being passed in through the constructor. Modifying the same `Interface` as was passed would have negative consequences if multiple `Modules` were consuming the same `Interface`, and also breaks the rules for `Module` input and output connectivity.

The `connectIO` function under the hood calls `addInput` and `addOutput` directly on the `Module` and connects those `Module` ports to the correct ports on the `Interfaces`. Connection is based on signal names. You can use the `uniquify` Function argument in `connectIO` to uniquify inputs and outputs in case you have multiple instances of the same `Interface` connected to your module. You can also use the `setPort` function to directly set individual ports on the `Interface` instead of via tagged set of ports.

## Serial Peripleral Interface (SPI)

Serial Peripheral Interface (SPI) is an interface bus commonly used to send data between microcontrollers and small peripherals such as shift registers, sensors, and SD cards. It uses separate clock and data lines, along with a select line to choose the device you wish to talk to.

Today, we are going to use ROHD interface to build the SPI peripheral shift register.
