// Modules
mod commands;
mod database;
mod etl;
mod storage;
mod utils;

use commands::connection::{test_connection, list_connections};

#[cfg_attr(mobile, tauri::mobile_entry_point)]
pub fn run() {
    tauri::Builder::default()
        .plugin(tauri_plugin_opener::init())
        .invoke_handler(tauri::generate_handler![
            test_connection,
            list_connections,
        ])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
