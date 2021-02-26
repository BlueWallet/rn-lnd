# rn-lnd

LND for React Native

## Installation

```sh
npm install rn-lnd
```

## Usage

```js
import RnLnd from "rn-lnd";

// ...

await RnLnd.start();
await RnLnd.initWallet('gsomgsomgsom', 'abstract rhythm weird food attract treat mosquito sight royal actor surround ride strike remove guilt catch filter summer mushroom protect poverty cruel chaos pattern');
// or await RnLnd.unlockWallet('gsomgsomgsom');  if its not the first run
console.warn(await RnLnd.getInfo());
```

## Installation

- Android: open `android/app/build.gradle` and add
  ```
  implementation files("../../node_modules/rn-lnd/android/libs/Lndmobile.aar")
  ```

## Example app

![image](https://user-images.githubusercontent.com/1913337/103314614-7f955e80-4a1b-11eb-9ee1-9834120e2c89.png)


## License

MIT
