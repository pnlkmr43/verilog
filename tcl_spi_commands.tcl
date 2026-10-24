
# --------------------------------------------------
# AXI Quad SPI v3.2 - JTAG Tcl example
# Base address: 0x44A00000
# --------------------------------------------------

set BASE 44A00000

# Register addresses
#set SRR   [expr {$BASE + 0x40}]
#set SPICR [expr {$BASE + 0x60}]
#set SPISR [expr {$BASE + 0x64}]
#set DTR   [expr {$BASE + 0x68}]
#set DRR   [expr {$BASE + 0x6C}]
#set SS    [expr {$BASE + 0x70}]

# Find JTAG-to-AXI master
set axi [lindex [get_hw_axis] 0]

if {$axi eq ""} {
    error "No JTAG-to-AXI master found"
}

puts "Using AXI master: $axi"

# AXI register write
proc axi_write {axi addr data} {
    create_hw_axi_txn write_tx -force -type WRITE -address $addr -data $data $axi
    run_hw_axi write_tx
    #report_hw_axi_txn $t
    #delete_hw_axi_txn $t
}

# AXI register read
proc axi_read {axi addr} {
    create_hw_axi_txn read_txn -force  $axi -type READ -address $addr -len 1
    run_hw_axi read_txn
    #report_hw_axi_txn read_txn
    #delete_hw_axi_txn read_txn
}

# 1. Read initial SPI control and status
puts "Initial SPICR:"
axi_read $axi 44A00060

puts "Initial SPISR:"

axi_read $axi 44A00064

axi_read $axi 44A00064

# 2. Software reset
axi_write $axi 44A00040 0000000A

# 3. Configure master, enable SPI, manual slave select,
#    and inhibit transfers while configuring
axi_write $axi 44A00060 00000186

# 4. Select slave 0 (active-low select)
axi_write $axi 44A00060 FFFFFFFE

# 5. Write one byte: 0x9A
axi_write $axi 44A00068 0000009A

# 6. Release transfer inhibit to start transfer
axi_write $axi 44A00060 00000086

# 7. Read status and receive data
puts "SPI status after transfer:"
axi_read $axi 44A00064

puts "SPI received data:"
axi_read $axi 44A0006C

# 8. Deselect slave
axi_write $axi 44A00070 FFFFFFFF

puts "SPI transaction completed"
