// Import necesarios
import { app, BrowserWindow } from 'electron';

let win: BrowserWindow;
function createWindow() {
  win = new BrowserWindow({ show: false });
  win.loadURL('https://b2b.novasolspray.com/');
  win.maximize();
  win.show();

  win.on('closed', () => {
    win = null;
  });
}
// Para ver el estado de la app
app.on('ready', createWindow);

app.on('activate', () => {
  if (win === null) {
    createWindow();
  }
});
