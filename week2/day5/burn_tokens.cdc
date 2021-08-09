import Kibble from Project.Kibble

transaction(amount: UFix64) {

    // A reference to the signer's stored vault
    let vaultRef: &Kibble.Vault

    prepare(signer: AuthAccount) {
        
        // Get a reference to the signer's stored vault
        self.vaultRef = signer.borrow<&Kibble.Vault>(from: Kibble.VaultStoragePath)
			?? panic("Could not borrow reference to the owner's Vault!")        
    }

    execute {
        // Withdraw tokens from the signer's stored vault to burn kibble amount
        let tempVault <- self.vaultRef.withdraw(amount: amount)

        destroy tempVault
    }
}
