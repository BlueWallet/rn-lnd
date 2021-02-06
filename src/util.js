/* eslint-disable no-bitwise */
/* eslint-disable no-shadow */

/* Convert base64 data to hex string.  https://stackoverflow.com/a/57909068/893578
 *   txt : Base64 string.
 *   sep : Hex separator, e.g. '-' for '1a-2b-3c'.  Default empty.
 */
const base64ToHex = (() => {
  // Lookup tables
  const values = [],
    output = [];

  // Main converter
  return function base64ToHex(txt, sep = '') {
    if (output.length <= 0) populateLookups();
    const result = [];
    let v1, v2, v3, v4;
    for (let i = 0, len = txt.length; i < len; i += 4) {
      // Map four chars to values.
      v1 = values[txt.charCodeAt(i)];
      v2 = values[txt.charCodeAt(i + 1)];
      v3 = values[txt.charCodeAt(i + 2)];
      v4 = values[txt.charCodeAt(i + 3)];
      // Split and merge bits, then map and push to output.
      result.push(output[(v1 << 2) | (v2 >> 4)], output[((v2 & 15) << 4) | (v3 >> 2)], output[((v3 & 3) << 6) | v4]);
    }
    // Trim result if the last values are '='.
    if (v4 === 64) result.splice(v3 === 64 ? -2 : -1);
    return result.join(sep);
  };

  function populateLookups() {
    const keys = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
    for (let i = 0; i < 256; i++) {
      output.push(('0' + i.toString(16)).slice(-2));
      values.push(0);
    }
    for (let i = 0; i < 65; i++) values[keys.charCodeAt(i)] = i;
  }
})();

module.exports.base64ToHex = base64ToHex;
