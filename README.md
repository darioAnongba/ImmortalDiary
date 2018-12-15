# Immortal Diary - Dario Anongba Varela, Nativity Carol

Immortal Diary of Dario Anongba Varela and Nativity Carol.
Most important moments of our live. Use it wisely, as you cannot go back and cannot delete it!

## Getting Started

If one day I'm not here anymore to tell you how to add stuff to the diary

### Prerequisites

I recommend you to install this tools before starting :

- [Npm](https://docs.npmjs.com/getting-started/installing-node) - NPM to manage packages
- [Truffle](https://truffleframework.com/) - Truffle Framework to test and compile smart contracts

### Project Architecture

| Folder            | Description                     |
| --------------    | ------------------------------- |
| contracts         | Smart Contracts in Solidity     |
| migrations        | Migrations files                |
| test              | Smart Contract tests            |

### Installing

1.  Install npm dependencies :

```
cd immortaldiary
npm install
```

2.  Create an `.env` file using `.env.example` as example. Use the right mnemonic or you won't be able to add stuff to the diary! Even if someone helps you, don't give them the key! Only if you really trust them.

### Compiling and migrating

1.  Connect to the desired network defined in `truffle.js`:

```
truffle console --network mainnet
```

2. Compile the smart contracts:

```
compile
```

3. Create an instance of the ImmortalDiary :

```javascript
const diary = ImmortalDiary.at(/* Add the address of the diary here */)
```

4. Add an event to the diary :

```javascript
diary.addEvent('Event short description': string, date: Datetime, location: string, by: string)
```
> Example: `diary.addEvent("Nati je t'aime", now(), 'Lausanne, Suisse', 'Dario')`

> Files will be stored in the `build/contracts` folder in JSON form, containing the ABI and other informations.