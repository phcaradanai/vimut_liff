export default {
  name: 'XENGISTIC_ML',

  apiUrl: process.env.VITE_API_URL ?? '/',

  secret: '[XML]',

  langList: [
    { value: 'th', text: 'ไทย' },
    { value: 'en', text: 'English' },
  ],

  yearFormatList: [
    { value: 'be', text: 'B.E.' },
    { value: 'ce', text: 'C.E.' },
  ],

  yearFormatDefault: 'be',
}
