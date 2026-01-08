#!/usr/bin/env bash
# Vyn Plugin System Module
# Plugin discovery, installation, and execution
# Version: 1.5.0

readonly PLUGINS_MODULE_VERSION="1.5.0"

# Initialize plugin system
init_plugin_system() {
    if [[ ! -d "$PLUGIN_DIR" ]]; then
        mkdir -p "$PLUGIN_DIR"
        print_info "📦 Plugin directory created: $PLUGIN_DIR"
    fi
    
    # Create example plugin
    local example_plugin="$PLUGIN_DIR/example.sh"
    if [[ ! -f "$example_plugin" ]]; then
        cat > "$example_plugin" << 'EOF'
#!/bin/bash
# Example Vyn Plugin
# This is a template for creating custom Vyn plugins

plugin_name="Example Plugin"
plugin_version="1.0.0"
plugin_description="Example plugin for custom video processing"

# Plugin function - gets called with input and output file paths
execute_plugin() {
    local input_file="$1"
    local output_file="$2"
    
    echo "🔌 Running Example Plugin on: $(basename "$input_file")"
    
    # Add your custom FFmpeg processing here
    # This example adds a subtle blur effect
    ffmpeg -i "$input_file" \
           -vf "boxblur=2:1" \
           -c:a copy \
           "$output_file" 2>/dev/null
    
    return $?
}

# Plugin validation (optional)
validate_plugin() {
    # Check if required tools are available
    if ! command -v ffmpeg >/dev/null 2>&1; then
        return 1
    fi
    return 0
}
EOF
        chmod +x "$example_plugin"
    fi
}

# Load plugins
load_plugins() {
    if [[ ! -d "$PLUGIN_DIR" ]]; then
        return 0
    fi
    
    local plugin_count=0
    for plugin in "$PLUGIN_DIR"/*.sh; do
        if [[ -f "$plugin" && -x "$plugin" ]]; then
            plugin_count=$((plugin_count + 1))
        fi
    done
    
    if [[ $plugin_count -gt 0 ]]; then
        print_info "📦 Found $plugin_count plugin(s) in $PLUGIN_DIR"
    fi
    
    return 0
}

# Execute plugin conversion
execute_plugin_conversion() {
    local input_file="$1"
    local output_file="$2"
    local plugin_name="$3"
    
    local plugin_path="$PLUGIN_DIR/${plugin_name}.sh"
    
    if [[ ! -f "$plugin_path" ]]; then
        print_error "Plugin not found: $plugin_name"
        return 1
    fi
    
    if [[ ! -x "$plugin_path" ]]; then
        print_error "Plugin not executable: $plugin_name"
        return 1
    fi
    
    # Source the plugin and execute
    source "$plugin_path"
    
    if declare -f execute_plugin >/dev/null; then
        print_info "🔌 Executing plugin: $plugin_name"
        execute_plugin "$input_file" "$output_file"
        return $?
    else
        print_error "Plugin missing execute_plugin function: $plugin_name"
        return 1
    fi
}

# Load plugin manifest
load_plugin_manifest() {
    if [[ ! -f "$PLUGIN_MANIFEST" ]]; then
        print_error "Plugin manifest not found: $PLUGIN_MANIFEST"
        return 1
    fi
    
    if ! command -v jq >/dev/null 2>&1; then
        print_error "jq is required for plugin management"
        print_info "Install with: sudo apt install jq (or brew install jq on macOS)"
        return 1
    fi
    
    return 0
}

# List available plugins (wrapper for compatibility)
list_available_plugins() {
    list_installed_plugins
}

# List available plugins from manifest
list_available_plugins_from_manifest() {
    if ! load_plugin_manifest; then
        return 1
    fi
    
    echo ""
    print_color "$PURPLE" "📦 Available Plugins (Repository)"
    echo ""
    
    local plugin_count
    plugin_count=$(jq '.plugins | length' "$PLUGIN_MANIFEST" 2>/dev/null)
    
    if [[ "$plugin_count" -eq 0 ]]; then
        print_warning "No plugins available in repository"
        return 1
    fi
    
    for (( i=0; i<plugin_count; i++ )); do
        local plugin_id plugin_name plugin_version plugin_description plugin_category
        
        plugin_id=$(jq -r ".plugins[$i].id" "$PLUGIN_MANIFEST")
        plugin_name=$(jq -r ".plugins[$i].name" "$PLUGIN_MANIFEST")
        plugin_version=$(jq -r ".plugins[$i].version" "$PLUGIN_MANIFEST")
        plugin_description=$(jq -r ".plugins[$i].description" "$PLUGIN_MANIFEST")
        plugin_category=$(jq -r ".plugins[$i].category" "$PLUGIN_MANIFEST")
        
        local status="Not Installed"
        if [[ -f "$PLUGIN_DIR/${plugin_id}.sh" ]]; then
            status="Installed"
        fi
        
        echo "$((i+1))) $plugin_name (v$plugin_version) [$plugin_category]"
        echo "   📝 $plugin_description"
        echo "   📊 Status: $status"
        echo ""
    done
    
    return 0
}

# Install plugin
install_plugin() {
    local plugin_ref="$1"
    
    if [[ -z "$plugin_ref" ]]; then
        print_error "Plugin reference required"
        return 1
    fi
    
    if ! load_plugin_manifest; then
        return 1
    fi
    
    local plugin_data plugin_id plugin_name plugin_file
    
    # Check if it's a number or plugin ID
    if [[ "$plugin_ref" =~ ^[0-9]+$ ]]; then
        local index=$((plugin_ref - 1))
        plugin_data=$(jq ".plugins[$index]" "$PLUGIN_MANIFEST" 2>/dev/null)
    else
        plugin_data=$(jq ".plugins[] | select(.id == \"$plugin_ref\")" "$PLUGIN_MANIFEST" 2>/dev/null)
    fi
    
    if [[ "$plugin_data" == "null" || -z "$plugin_data" ]]; then
        print_error "Plugin not found: $plugin_ref"
        return 1
    fi
    
    plugin_id=$(echo "$plugin_data" | jq -r '.id')
    plugin_name=$(echo "$plugin_data" | jq -r '.name')
    plugin_file=$(echo "$plugin_data" | jq -r '.file')
    
    # Check if already installed
    if [[ -f "$PLUGIN_DIR/${plugin_id}.sh" ]]; then
        print_warning "Plugin '$plugin_name' is already installed"
        read -r -p "Do you want to reinstall it? (y/N): " reinstall
        if [[ ! "$reinstall" =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled"
            return 0
        fi
    fi
    
    # Create plugin directory if it doesn't exist
    if [[ ! -d "$PLUGIN_DIR" ]]; then
        mkdir -p "$PLUGIN_DIR"
        print_info "📦 Created plugin directory: $PLUGIN_DIR"
    fi

    # Download plugin file
    local github_url="https://raw.githubusercontent.com/samonide/vyn/main/plugins/$plugin_file"
    local dest_file="$PLUGIN_DIR/${plugin_id}.sh"
    
    print_info "🌐 Downloading plugin from GitHub..."
    
    if curl -fsSL "$github_url" -o "$dest_file"; then
        chmod +x "$dest_file"
        print_success "✅ Plugin '$plugin_name' installed successfully"
        
        # Show setup instructions if required
        local setup_required
        setup_required=$(echo "$plugin_data" | jq -r '.setup.required // false')
        
        if [[ "$setup_required" == "true" ]]; then
            echo ""
            print_color "$YELLOW" "⚙️  Setup Required"
            local setup_description
            setup_description=$(echo "$plugin_data" | jq -r '.setup.description')
            echo "$setup_description"
            echo ""
            
            local instructions_count
            instructions_count=$(echo "$plugin_data" | jq '.setup.instructions | length')
            
            for (( j=0; j<instructions_count; j++ )); do
                local instruction
                instruction=$(echo "$plugin_data" | jq -r ".setup.instructions[$j]")
                echo "   $instruction"
            done
            echo ""
        fi
        
        return 0
    else
        print_error "Failed to install plugin: $plugin_name"
        return 1
    fi
}

# List installed plugins
list_installed_plugins() {
    echo ""
    print_color "$PURPLE" "📦 Installed Plugins"
    
    if [[ ! -d "$PLUGIN_DIR" ]] || [[ -z "$(ls -A "$PLUGIN_DIR"/*.sh 2>/dev/null)" ]]; then
        print_warning "No plugins installed"
        echo ""
        print_info "💡 Use 'vyn --add-plugins' to install plugins"
        return 1
    fi
    
    local count=1
    for plugin in "$PLUGIN_DIR"/*.sh; do
        if [[ -f "$plugin" && -x "$plugin" ]]; then
            local plugin_name=$(basename "$plugin" .sh)
            
            # Try to get plugin info from the file
            local plugin_display_name plugin_version plugin_description
            
            if source "$plugin" 2>/dev/null && declare -p plugin_name plugin_version plugin_description >/dev/null 2>&1; then
                plugin_display_name="$plugin_name"
                echo "$count) $plugin_display_name (v$plugin_version)"
                echo "   📝 $plugin_description"
            else
                echo "$count) $(basename "$plugin" .sh)"
                echo "   📝 Custom plugin"
            fi
            
            echo "   📂 $(basename "$plugin")"
            echo ""
            count=$((count + 1))
        fi
    done
    
    return 0
}

# Remove plugin
remove_plugin() {
    local plugin_ref="$1"
    
    if [[ -z "$plugin_ref" ]]; then
        print_error "Plugin reference required"
        return 1
    fi
    
    if [[ ! -d "$PLUGIN_DIR" ]]; then
        print_error "No plugins directory found"
        return 1
    fi
    
    local plugin_file=""
    
    # Check if it's a number or plugin name
    if [[ "$plugin_ref" =~ ^[0-9]+$ ]]; then
        local count=1
        for plugin in "$PLUGIN_DIR"/*.sh; do
            if [[ -f "$plugin" && -x "$plugin" ]]; then
                if [[ $count -eq $plugin_ref ]]; then
                    plugin_file="$plugin"
                    break
                fi
                count=$((count + 1))
            fi
        done
    else
        plugin_file="$PLUGIN_DIR/${plugin_ref}.sh"
    fi
    
    if [[ ! -f "$plugin_file" ]]; then
        print_error "Plugin not found: $plugin_ref"
        return 1
    fi
    
    local plugin_name=$(basename "$plugin_file" .sh)
    
    echo ""
    print_warning "Are you sure you want to remove plugin '$plugin_name'?"
    read -r -p "This action cannot be undone (y/N): " confirm
    
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        if rm "$plugin_file"; then
            print_success "✅ Plugin '$plugin_name' removed successfully"
            return 0
        else
            print_error "Failed to remove plugin: $plugin_name"
            return 1
        fi
    else
        print_info "Removal cancelled"
        return 0
    fi
}

# Interactive plugin management
interactive_plugin_management() {
    local action="$1"
    
    if [[ "$action" == "add" ]]; then
        echo ""
        print_color "$BLUE" "🔌 Plugin Installation"
        echo "=============================="
        
        if ! list_available_plugins_from_manifest; then
            return 1
        fi
        
        echo ""
        read -r -p "Enter plugin number to install (or 'q' to quit): " choice
        
        if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
            print_info "Installation cancelled"
            return 0
        fi
        
        install_plugin "$choice"
        return $?
    elif [[ "$action" == "remove" ]]; then
        if ! list_installed_plugins; then
            return 1
        fi
        
        echo ""
        read -r -p "Enter plugin number to remove (or 'q' to quit): " choice
        
        if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
            print_info "Removal cancelled"
            return 0
        fi
        
        remove_plugin "$choice"
        return $?
    fi
}

# Module info
plugins_module_info() {
    echo "Vyn Plugins Module v${PLUGINS_MODULE_VERSION}"
}
