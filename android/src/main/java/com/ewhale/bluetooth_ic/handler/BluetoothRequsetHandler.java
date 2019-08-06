package com.ewhale.bluetooth_ic.handler;

import io.flutter.plugin.common.PluginRegistry;

/**
 * @author Puppet
 */
public class BluetoothRequsetHandler {
    private static PluginRegistry.Registrar registrar = null;

    public static void setRegistrar(PluginRegistry.Registrar reg) {
        BluetoothRequsetHandler.registrar = reg;
    }

    public PluginRegistry.Registrar getRegistrar() {
        return registrar;
    }
}
