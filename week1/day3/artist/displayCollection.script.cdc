import Artist from "./contract.cdc"

// Return an array of formatted Pictures that exist in the account with the a specific address.
// Return nil if that account doesn't have a Picture Collection.
pub fun main(address: Address): [String] {    

    let account = getAccount(address)
    let collectionRef = account
      .getCapability(/public/ArtistPictureCollection)
      .borrow<&Artist.Collection>()
      ?? panic("Couldn't borrow Collection reference")
    
    var pictures: [String] = []

    if collectionRef != nil {        
        for canvas in collectionRef!.getCanvases() {            
            pictures.append(canvas.pixels)
        }
    }

    return pictures
}