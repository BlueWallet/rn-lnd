import { NativeModules } from 'react-native';

type RnLndType = {
  multiply(a: number, b: number): Promise<number>;
};

const { RnLnd } = NativeModules;

export default RnLnd as RnLndType;
