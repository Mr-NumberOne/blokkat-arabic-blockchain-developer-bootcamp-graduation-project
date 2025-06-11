# **CharityOne - web3 DApp**

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![GitHub Repository](https://img.shields.io/badge/GitHub-Repository-blue?logo=github)](https://github.com/Mr-NumberOne/blokkat-arabic-blockchain-developer-bootcamp-graduation-project.git)

This is a web3 based donation website
---

## 📖 About This Project

*Charity One is a web3 solution that aims to manage and collect donations for charitable causes*
- It provides many features such as:

- Creation and Modification to charitable causes (only by the contract deployer)

- Causes can be features which will have place in the sites home page

- Tracking of all the causes total donation and the total number of donars

- Allowing visitors to donate to the causes they prefer
---

## 🧱 Technology Stack

- Charity One is built using a modern Web3 technology stack, including:

- Solidity: Powers the smart contracts that manage donation logic, cause creation, and access control on the Ethereum blockchain.

- ext.js: A React-based framework used for building a fast, responsive frontend with support for server-side rendering and routing.

- Wagmi: A set of React hooks that simplifies Ethereum development by handling wallet connections, contract interactions, and state management.

- Viem: Used alongside Wagmi to enable seamless and type-safe communication with smart contracts.
---

## 📁 Directory Structure

A well-organized repository is crucial for maintainability. Below is the structure of this project:
### 📁Part One Backend

```
.
├── 📁contracts/
│   └── 📄CauseRegistry.sol
├── 📁frontend/
├── 📁test/
│   └── 📄CauseRegistry.t.sol
├── 📁.github/
│   └── 📁workflows/
│       └── 📄test.yml
├── 📄env.example
├── 📄.gitignore
├── 📄.gitmodules
├── 📄foundry.toml
└── 📄Makefile
└── 📄README.md
```

-   **`contracts/`**: Contains all the Solidity smart contracts for the project.
-   **`frontend/`**: Contains the frontend of the DApp.
-   **`test/`**: Includes the tests for your smart contracts, also written in Solidity.
-   **`.github/workflows/`**: (with foundry) Contains the Continuous Integration (CI) workflow for automated testing using GitHub Actions.
-   **`env.example`**: An example file showing the environment variables needed to run the project.
-   **`.gitignore`**: Specifies which files and directories to ignore in version control.
-   **`.gitmodules`**: Specifies which modules are needed in the project.
-   **`foundry.toml`**: The main configuration file for the Foundry project.
-   **`README.md`**: This file, providing an overview and documentation for the project.

### 📁Part Two Frontend
```
📁 Frontend/
├── 📁 app/
│   ├── 📁 about/
│   ├── 📁 causes/
│   ├── 📁 contact/
│   ├── 📁 dashboard/
│   ├── 📁 faq/
│   ├── 📁 impact/
│   ├── 📁 privacy/
│   └── 📁 terms/
├── 📁 components/
│   ├── 📁 dashboard/
│   ├── 📁 dialogs/
│   └── 📁 ui/
├── 📁 config/
├── 📁 context/
├── 📁 hooks/
├── 📁 lib/
│   └── 📁 abi/
├── 📄 .gitignore
├── 📄 next.config.js
├── 📄 env.example
├── 📄 package.json
├── 📄 README.md
├── 📄 tailwind.config.ts
└── 📄 tsconfig.json
```
## Directory & File Descriptions

-   **`app/`**: Contains the core routing and pages of the Next.js application. Each sub-folder represents a different web page or route (e.g., `/about`, `/causes`). This uses the Next.js App Router paradigm.
-   **`components/`**: Holds all the reusable React components for the user interface (UI).
    -   **`components/dashboard/`**: Specific components used only within the admin dashboard.
    -   **`components/dialogs/`**: Reusable modal/dialog components, such as for adding or editing a cause.
    -   **`components/ui/`**: General-purpose UI elements provided by `shadcn/ui` like buttons, cards, and input fields.
-   **`config/`**: Stores global configuration for the application, such as wallet and network settings required for interacting with the blockchain via libraries like Wagmi.
-   **`context/`**: Contains React Context providers for managing global state across the application. This is used for state that needs to be accessed by many components at different levels of the component tree.
-   **`hooks/`**: Includes custom React hooks that encapsulate reusable logic. This is particularly useful for interacting with smart contracts (e.g., `useContractEvent`, `useIsOwner`) and other side effects.
-   **`lib/`**: A library folder for shared utilities, data, type definitions, and smart contract Application Binary Interfaces (ABIs).
    -   **`lib/abi/`**: Stores the ABI JSON files for the Solidity smart contracts, allowing the frontend to know how to interact with them.
-   **`.gitignore`**: Specifies which files and directories to ignore in Git version control, such as `node_modules` and environment variable files (`.env`).
-   **`next.config.js`**: The main configuration file for the Next.js framework, where you can customize its behavior.
-   **`package.json`**: Lists the project's dependencies (e.g., React, Next.js, Ethers) and defines scripts for running, testing, and building the application (e.g., `npm run dev`).
-   **`env.example`**: An example file showing the environment variables needed to run the project.
-   **`README.md`**: This file, providing an overview, setup instructions, and general documentation for the project.
-   **`tailwind.config.ts`**: The configuration file for the Tailwind CSS utility-first framework, used for styling the application.
-   **`tsconfig.json`**: The configuration file for the TypeScript compiler. It specifies the root files and the compiler options required to compile the project.



---

## 🎨 Design Patterns

In this project, I've implemented the following design patterns to ensure the code is robust, secure, and maintainable according to the requirements of the bootcamp.

1.  **Inheritance and Interfaces**:
    * **Description**: I have inherited one of openzeppelin's contracts "**`Ownable`**" to make sure some functions are only triggered by the owner 
    * **Implementation Location**:  `This can be found in the CauseRegistry.sol file, in the class definition and constroctor on lines 21 and 74.`
2.  **Access Control Design Patterns (Ownable)**:
    * **Description**: I have used one of openzeppelin's contracts "**`Ownable`**" to make sure some functions are only triggered by the owner 
    * **Implementation Location**:  `This can be found in the CauseRegistry.sol file, in the addCause() and updateCause() functions on lines 80 and 110.`

3.  **Optimizing Gas**:
    * **optimization - 1**: I have implemeted som gas optimizations such as using **`revert()`** only when nessasary.
    * **Implementation Location**:  `The implementation is located in the CauseRegistry.sol file, implemented in almost every method`


    * **optimization - 2**: I have used custom errors instead of **`require()`** statements to avoid error message storing on the chain. more details on **`require()`** vs custom statements can be found [here](https://medium.com/coinmonks/mastering-solidity-require-and-custom-errors-in-ethereum-contracts-b491565f1592#80f2)
    * **Implementation Location**:  `The implementation is located in the CauseRegistry.sol file, implemented in almost every method, and the error definetion is on line 7-13`


    * **optimization - 3**: I have avoided creating a **`getallClauses()`** method, to avoid using loops which will consume gas as the number of causes grow do to hug on chain computation, so instead I only created a **`getCause(id)`** method .
    * **Implementation Location**:  `The implementation is located in the CauseRegistry.sol file, implemented in almost every method`

---

## 🛡️ Security Measures

Security is paramount in blockchain development. I have incorporated the following security best practices according to the requirements of the bootcamp:

1.  **Using Specific Compiler Pragma (not a range)**:
    * **Description**: I uses a specific compiler number to insure that the contract is always compiles using the same version and I choose the latest solidity version **`8.0.30`**
    * **Implementation Location**: `I've used this measure in the CauseRegistry.sol file on line 2.`

2.  **modifiers only for validation**:
    * **Description**: the only modifier I used in the project was **`onlyOwner`** from the **`Ownable`** contract and it is only used for validation the owner
    * **Implementation Location**:  `This can be found in the CauseRegistry.sol file, in the addCause() and updateCause() functions on lines 80 and 110.`

3.  **Checks-Effects-Interactions**:
    * **Description**: I have made that the interactions sequence in the **`donateToCause(uint256 _id)`** is checks => transfer => emitting events
    * **Implementation Location**:  `This can be found in the CauseRegistry.sol file, in the donateToCause(uint256 _id) function on line 132-150.`


---

## 🔗 Important Links & Addresses

Here are the essential links and contract addresses for this project on the **Scroll Sepolia** testnet.

* **Contract Addresses on Scroll Sepolia**:
    * `CauseRegistry`: `0x0BeC44eb3A4096F510E2f523BD133F573A3EFc22`
* **Verified Smart Contracts on Scroll Sepolia Explorer**:
    * [Link to CauseRegistry on Scrollscan](https://sepolia.scrollscan.com/address/0x0BeC44eb3A4096F510E2f523BD133F573A3EFc22)
    > **_NOTE:_**  The verification on scrollscan was unsuccessfull due to the **`viaIR`** issue, however it works fine when configured locally - but I plan on understanding the issue
* **Hosted DApp Frontend**: was not published due to build errors at the end <<>>
* **Project GitHub Repository**: [https://github.com/Mr-NumberOne/blokkat-arabic-blockchain-developer-bootcamp-graduation-project.git](https://github.com/Mr-NumberOne/blokkat-arabic-blockchain-developer-bootcamp-graduation-project.git)

---

## 🧪 How to Run Tests

To run the test suite for the smart contracts, follow these steps. All tests are located in the `test/` directory and can be run from the project's root directory.

1.  Clone the repository:
    ```shell
    git clone https://github.com/Mr-NumberOne/blokkat-arabic-blockchain-developer-bootcamp-graduation-project.git
    cd blokkat-arabic-blockchain-developer-bootcamp-graduation-project
    ```
2.  Install Foundry dependencies:
    ```shell
    forge install
    ```
3.  Run the tests with the following command:
    ```shell
    forge test -vvv
    ```
    This command will execute all tests and provide a verbose output of the results.

---

## 🚀 How to Run the Program Locally

To get a local instance of this project up and running, follow these instructions.

### 1. Setup Environment and deploy contract

First, you need to set up your environment variables. Create a `.env` file in the root directory by making a copy of the `.env.example` file.

```shell
cp .env.example .env
```

Then, open the `.env` file and add your own data. It must be structured as follows:

```
PRIVATE_KEY="Your Private key"
RPC_URL="https://sepolia-rpc.scroll.io"
OWNERS_ADDRESS="the deployers address ex: 0x0000..."
```

> **_NOTE:_**  keep you PRIVATE_KEY safe, you can use **`forge create CauseRegistry --constructor-args ${OWNERS_ADDRESS} --rpc-url <url> --interactive --broadcast`** in the makefile to enter the key at run time

Then in the terminal in the project folder run the command
```shell
make deploy
```
> **_NOTE:_**  make show **`make`** is installed on you device'

```shell
# if not insalled run this
sudo apt update
sudo apt install make
```

### 2. run the frontend to interact with the deployed contract

Once your environment variables are set, you can deploy and interact with the contracts.

1.  **Start the Frontend**:
    If you have a frontend application, navigate to its directory and run the necessary commands.
    ```shell
    cd frontend
    npm install
    npm run dev
    ```
2.  First, you need to set up your environment variables. Create a `.env` file in the root directory by making a copy of the `.env.example` file.

    ```shell
    cp .env.example .env
    ```

    Then, open the `.env` file and add your own data. It must be structured as follows:

    ```
    NEXT_PUBLIC_PROJECT_ID="A public rewon project ID"
    NEXT_PUBLIC_CAUSE_REGISTRY_ADDRESS="The Contracts address you got when deploying the contract"
    ```
    > **_NOTE:_**  the project id can be gotten from [reown](https://reown.com/) follow the steps here [Lecture 16 - Arabic Blockchain Developer Bootcamp](https://youtu.be/KHpKDLSskQQ?list=PLt62EXa7u8Ao0tgTPS7APiLg3_wljT_TT&t=1654) or you can use 
    the one in the **`.env.example`** which will be deleted in a month

---

## 🎬 Demo

Watch a full walkthrough of the DApp in action. This video covers everything from interacting with the user interface to sending transactions and viewing the results on the Scroll Sepolia explorer. It demonstrates how a transaction is sent from the frontend to the smart contract, how to find the transaction on the Scroll Sepolia explorer, and how the frontend reads and displays the new data from the smart contract.

My Demo can be watched [here)](https://youtu.be/D2U6cdZrQLw)


## 🙌 What is next for Charity One
- I plan on integrating it with a web2 Database to store data that needs to be stored but not on the chain, such as user preferences and other features such as
    - comunications with the sites owner 
    - videos of real causes impacts in the comunity 
    - add conication amoung charities 
- refactor and enhance the UI/UX of the site
- add donation tracking for each cause

## 📒 Final Notes for the Bootcamp
- I had planned for 2 features that I faced problems implementing \
    - allowing automatic refresh when a Cause is created or updated or a donation is Made using **`useContractWriteEvent`** from wagmi
    - verfiying the contract on Scrollscan due to **`ViaIR`** and optimization issues when compiled on Remix
    - I had an issue deploying my next.js DApp because i am facing issues with running **`npm run dev`** due to an issue with **`/@walletconnect/heartbeat`**
    > **_NOTE:_** The frontend was a templete genarated by AI, and AI was used as a study buddy and initial documentor
- *Finally*, I hope this project could hold to you expectations of the bootcamps graduates