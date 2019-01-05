function complexH = Channel_iid(nRx,nTx)
complexH = randn (nRx,nTx)/sqrt(2) + 1i*randn(nRx,nTx)/sqrt(2);
end