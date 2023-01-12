# Rapid Open Hardware Development (ROHD)

Rapid Open Hardware Development Framework (ROHD) is a generator framework for decribing and verifying hardware in the Dart programming language. ROHD enables you to build and traverse a graph of connectivity between module objects using unrestricted software.

ROHD is an ambitous project that aims to replace system verilog as the industry-standard choice for front-end hardware development.

## Challenges in Hardware Industry

A lot of people is curious on why its necessary to overhaul so much legacy which has been proof effective for so long. 

Below, we will details and list the reason of why ROHD is so powerful as we view it as a standard.

- **SystemVerilog is not good enough**
When we talk about front-end hardware design or development, SystemVerilog(SV) is like first come into your mind. But, the things about SV is it is too limited for hardware description. Many people use tools for hardware generation and connectivity such as (collage, chef, visa, defacto, ipxact, ziler) due to SystemVerilog's limitation.

- **SystemVerilog is a poort language for testbenches**
Some would disagrre, but we believe that testbenches are software. Nobody writes any software in SystemVerilog unless there are a verification engineer, because it's not a great option for software development. We use SV testbench because its convenient to interact with hardware and related tooling in the same language and toolstack.

- **Integration and reuse of code are too difficult**
Integration and reuse of code are way too difficult to the extend that project requires weeks to months to integrate the same IP.

- **Slow Development Iteration Time**
Hardware development also suffers from very slow iteration time. By iteration, this mean when code changed to finding out if the changed worked, which usually involves a build and simulation. Smaller IPs might need to wait only tens of minutes or hours per iteration, but large SoCs can take days to iterate.

- **Existing altenatives are insufficient**
Well, you might think why not chisel or cocotb? Its already been there right? We created ROHD because none of the existing altenatives really address the entire set of problems. Some treat verification as second class, which is strange since we spend twice as much effort on verification as design. Some solutions are academic in nature, but not ready in production. Theres born ROHD as an execution ready solution.

- **Open-Source hardware community is lacking**
The open-source hardware community is nearly non-existent.  You may find some open-source generators or cores, but they have varying quality. It’s tough to find many open-source verification components, and there aren’t even any open-source or free tool stacks that can run UVM testbenches. This means hardware engineers are often unfamiliar with open-source development. 

The software industry figured out a long time ago that collaborating on open-source projects, even with competitors, is a worthwhile investment. Hardware engineers spend too much time on the wrong work: struggling with bad tools and infrastructure. Teams should be focusing on their competitive advantages instead of bad tools.


## Feature of ROHD

- A framework in in Dart language for describing and verifying 
hardware
    - Dart is a modern, fast language developed by Google
- Build connectivity between module objects
    - Generate with unrestricted software
- ROHD modules map one-to-one
    - Structurally similar, human readable SV
    - Extensible generation (CIRCT, UPF, etc.)
- Built-in fast simulator
    - Includes waveform dumper
    - Cosimulation with SV modules via VPI
- Easy IP integration and interfaces
    - Just depend on and then import IP to integrate it
- Verification collateral simpler to develop and debug
    - Testbenches in Dart with a UVM-like framework
    - Interact with signals and events ituitively
- Includes convenient abstractions
    - Pipelining, FSMs and more
- Use pub.dev package manager
    - Share code without friction
    - Automatically manage dependencies
- Fast and simple build
    - No complex build system or EDA vendoe tools
- Develop code in modern IDE
    - Powerful static analysis and debug features
