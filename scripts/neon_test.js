require('dotenv').config({ path: require('path').resolve(__dirname, '../.env') });

const { neon } = require('@neondatabase/serverless');

async function main() {
  try {
    const sql = neon(process.env.DATABASE_URL);
    const result = await sql`SELECT version()`;
    console.log(result[0].version);
  } catch (error) {
    console.error('Error connecting to the database:', error);
  }
}

main();
