#Name               :  Creation of virtual machines
#Description        :  Automatic creation of a virtual machine via the import of a csv file
#Version            :  1.0
#Author             :  Saba BEROL
#Last modification  :  02/06/2019

    #-------------------------------------------------------------------------#
    #                    DEPLOY FUNCTION                                      #
    #-------------------------------------------------------------------------#
function Option1
{
	Import-Module VMware.VimAutomation.Core
	$PassKey = [byte]95, 13, 58, 45, 22, 11, 88, 82, 11, 34, 67, 91, 19, 20, 96, 82
	$Password =  'Qwerty!1'
	$User = 'administrator@vcenter.local'
	Connect-VIServer -Server 172.180.0.150 -User administrator@vcenter.local -Password Qwerty!1
	
    $vms = Import-Csv ".\VMs.csv" -Delimiter ";" #Import Csv file
    $dateVM = get-date -f "yyyy-MM-dd-H:m:s:ffffff" #Get the date to record it in the vm description, to date the logs etc
    $mess = ".\TmpMess.txt"

    ForEach ($vm in $vms)
    {
        $VMName = $vm.Name
        $VMHost = Get-VMHost -Name $vm.Host
        $Datastore = Get-Datastore -Name $vm.Datastore
        $Disk = $vm.Disk
        $GuestID = $vm.GuestID #[VMware.Vim.VirtualMachineGuestOsIdentifier].GetEnumValues() ->  guestID list
        

 
                if ((Get-VM $VMName -ErrorAction SilentlyContinue).Name -eq $VMName) {  
                    $mailboxdata = "$VMName KO, already exist"
                }

                else {
                    New-VM -Name $VMName -GuestId $GuestID -VMHost $VMHost -Datastore $Datastore -DiskStorageFormat EagerZeroedThick -NumCPU 2 -MemoryMB 1572 -Notes "$VMName created on $dateVM" -CD -Floppy -DiskGB $Disk
                    if ($? -eq "True"){
                        $mailboxdata = "$VMName OK, Successfully completed deployment"
                    }
                    else {
                        $mailboxdata = "$VMName KO, Error during deployment"
                    }
				}
    }
}

Option1
