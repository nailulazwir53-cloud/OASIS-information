import express, { Express } from 'express';
import dotenv from 'dotenv';
import { connectDatabase } from './config';
import { errorHandler } from './middleware/errorHandler';
import paperRoutes from './routes/papers';

dotenv.config();

const app: Express = express();
const port = process.env.PORT || 3003;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'paper-service' });
});

// Routes
app.use('/api/papers', paperRoutes);

// Error handling
app.use(errorHandler);

// Start server
async function start() {
  try {
    await connectDatabase();
    app.listen(port, () => {
      console.log(`Paper service listening on port ${port}`);
    });
  } catch (error) {
    console.error('Failed to start service:', error);
    process.exit(1);
  }
}

start();
