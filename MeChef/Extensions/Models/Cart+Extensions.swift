extension LocalCart {

    func copyWith(products: [Int64], chefId: Int64? = nil) -> LocalCart? {
        return LocalCart(id: id,
                         products: products,
                         chefId: chefId)
    }

}
