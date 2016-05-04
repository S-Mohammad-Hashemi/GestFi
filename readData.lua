require 'torch'
require 'nn'
require 'nnx'
require 'dok'
require 'image'
require 'optim'


require 'torch'
require 'nn'
require 'nnx'
require 'dok'
require 'image'
require 'optim'
--require 'dataset-mnist'
--require 'sgd'
--require 'ConfusionMatrix'
----------------------------


print("first line in main file")


opt={}
opt.learningRate=0.001
opt.full=false
opt.batchSize=1
opt.optimization="SGD"
opt.momentum=0
opt.coefL1=0
opt.coefL2=0
opt.learningRate=0.05

-- fix seed
torch.manualSeed(1)

-- threads
torch.setnumthreads(4)
print('<torch> set nb of threads to ' .. torch.getnumthreads())

 torch.setdefaulttensortype('torch.FloatTensor')

----------------------------------------------------------------------
-- define model to train
-- on the 10-class classification problem
--
classes = {'1','2','3','4'}

-- geometry: width and height of input images
--geometry = {3584}
geometry={9,5000}
--geometry={56,64}
--


total_test=0
correct = 0
class_performance = {}
class_num = {}
for i=1, #classes do
      class_performance[i] = 0
      class_num[i] = 0
      print "ok"
end
--os.exit()
--fsize=geometry[1]
trainData={}
testData={}
train_size=24*4

--test_size=30*4-train_size
test_size=1
--train_size=30

trainData.data=torch.Tensor(train_size, 1, geometry[1],geometry[2])
trainData.labels = torch.Tensor(train_size)
testData.data=torch.Tensor(test_size, 1, geometry[1],geometry[2])
testData.labels = torch.Tensor(test_size)
total_train=0
total_test=0
model=nn.Sequential()
model:add(nn.SpatialConvolution(1, 6, 5, 5))
model:add(nn.ReLU())
model:add(nn.SpatialMaxPooling(2, 2, 2, 1))
model:add(nn.SpatialConvolution(6, 16, 5, 4))
model:add(nn.ReLU())
model:add(nn.SpatialMaxPooling(2, 1, 1, 1))

model:add(nn.SpatialConvolution(16, 32, 5, 1))
model:add(nn.ReLU())
model:add(nn.SpatialMaxPooling(2, 1, 2, 1))

model:add(nn.Reshape(32*1*1244))
--model:add( nn.Linear(16*20, 20) )
model:add( nn.Linear(32*1*1244, #classes) )
--model=torch.load('train_5fingers','ascii')
--model = nn.Sequential()
--model:add(nn.SpatialConvolution(1, 6, 5, 5))
----model:add(nn.ReLU())
--model:add(nn.Sigmoid())
--model:add(nn.SpatialMaxPooling(2, 2, 2, 2))
--model:add(nn.SpatialConvolution(6, 16, 5, 5))
----model:add(nn.ReLU())
--model:add(nn.Sigmoid())
--model:add(nn.SpatialMaxPooling(2, 2, 2, 2))
--model:add(nn.Reshape(16*3*3))
--model:add(nn.Linear(16*3*3, #classes))
----model:add(nn.Linear(16*3*3, 84))
----model:add(nn.Linear(84, #classes)) 
model:add(nn.LogSoftMax())
parameters,gradParameters = model:getParameters()
criterion = nn.ClassNLLCriterion()
confusion = optim.ConfusionMatrix(classes)


function createDataset(sound,label)
  index=total_train%train_size + 1
  total_train=total_train+1
  sound = sound:resize(1,geometry[1],geometry[2])
--  sound2=torch.FloatTensor():set(sound)
--  frameY = image.scale(sound2,32,32)
  trainData.data[index]=sound
  trainData.labels[index]=label
end

function createTestset(sound,label)
  index=total_test%test_size + 1
  total_test=total_test+1
  sound = sound:resize(1,geometry[1],geometry[2])
  testData.data[index]=sound
  testData.labels[index]=label
end



function trainData:size()
          return self.data:size(1)
end





-- training function
  randIndexes=torch.randperm(train_size)
function train(dataset)
   -- epoch tracker
   epoch = epoch or 1

   -- local vars
  local time = sys.clock()
  local my_time=os.clock()
   -- do one epoch
   print('<trainer> on training set:')
   print("<trainer> online epoch # " .. epoch .. ' [batchSize = ' .. opt.batchSize .. ']')
   for t = 1,dataset:size(),opt.batchSize do
      -- create mini batch
      local inputs = torch.Tensor(opt.batchSize,1,geometry[1],geometry[2])
      local targets = torch.Tensor(opt.batchSize)
      local k = 1
--      print ( "QQQQ" .. dataset:size())
      for i = t,math.min(t+opt.batchSize-1,dataset:size()) do
         -- load new sample
         local sample = dataset[randIndexes[i]]
         local input = sample[1]:clone()
         local _,target = sample[2]:clone():max(1)
         target = target:squeeze()
         inputs[k] = input
         targets[k] = target
         k = k + 1
      end

      -- create closure to evaluate f(X) and df/dX
      local feval = function(x)
         -- just in case:
         collectgarbage()

         -- get new parameters
         if x ~= parameters then
            parameters:copy(x)
         end

         -- reset gradients
         gradParameters:zero()

         -- evaluate function for complete mini batch
         local outputs = model:forward(inputs)
         local f = criterion:forward(outputs, targets)

         -- estimate df/dW
         local df_do = criterion:backward(outputs, targets)
         model:backward(inputs, df_do)

         -- penalties (L1 and L2):
         if opt.coefL1 ~= 0 or opt.coefL2 ~= 0 then
            -- locals:
            local norm,sign= torch.norm,torch.sign

            -- Loss:
            f = f + opt.coefL1 * norm(parameters,1)
            f = f + opt.coefL2 * norm(parameters,2)^2/2

            -- Gradients:
            gradParameters:add( sign(parameters):mul(opt.coefL1) + parameters:clone():mul(opt.coefL2) )
         end

         -- update confusion
         for i = 1,opt.batchSize do
            confusion:add(outputs[i], targets[i])
         end

         -- return f and df/dX
         return f,gradParameters
      end

      -- optimize on current mini-batch
   
      if opt.optimization == 'SGD' then

         -- Perform SGD step:
         sgdState = sgdState or {
            learningRate = opt.learningRate,
            momentum = opt.momentum,
            learningRateDecay = 5e-7
         }
         optim.sgd(feval, parameters, sgdState)
      
         -- disp progress
         --xlua.progress(t, dataset:size())

      else
         error('unknown optimization method')
      end
   end
   
   -- time taken
   time = sys.clock() - time
   time = time / dataset:size()
   print("<trainer> time to learn 1 sample = " .. (time*1000) .. 'ms')
  my_time=os.clock() - my_time
  my_time=my_time / dataset:size()
   print("<trainer> my_time to learn 1 sample = " .. (my_time*1000) .. 'ms')

   -- print confusion matrix
   print(confusion)
--  confusion:updateValids()
--  print(confusion.totalValid*100 .. "%  <==== global correct")
   confusion:zero()

--   torch.save('mnist.net', model)

   -- next epoch
   epoch = epoch + 1
end


function startTrain(maxIter)
  setmetatable(trainData,
    {__index = function(t, ii)
--      print("HEY")
--      print(t)
--      print("EEE")
--      print(t.labels[ii])
        return {t.data[ii], t.labels[ii]}
      end
      }
    );
  criterion = nn.ClassNLLCriterion()
  trainer = nn.StochasticGradient(model, criterion)
  trainer.learningRate = 0.001
  trainer.maxIteration = maxIter
  print "HHHHHHHHqqqqq"
--  torch.save('train_data',trainData,'ascii')
  trainer:train(trainData)
--  torch.save('freq_model_sun.net',model,'ascii')
  
end



function start_test()
  
  local preds = model:forward(testData.data)
  -- confusion:
  for i = 1,test_size do
    confusion:add(preds[i], testData.labels[i])
  end

  print(confusion)
  retVal=0
  if(confusion.totalValid*100>=96) then
    retVal=1
  end 
  confusion:zero()
  return retVal
end





function trainMore(counter)
local labelvector = torch.zeros(10)

setmetatable(trainData, {__index = function(self, index)
--            print("index " .. index)
           local input = self.data[index]
           local class = self.labels[index]
           local label = labelvector:zero()
--           print("class " .. class)
           label[class] = 1
--           print(label)
           local example = {input, label}
--           print("ok")
                                       return example
   end})
  i=0
  while(i<counter) do
    train(trainData)
--    start_test()
    i=i+1
  end
  
end


---------------------------------- MAIN ----------------------
print "hellooooo"
dir_names={'J_Push','J_Right','J_Up','J_Left'}
for k=1, 4 do 
  dir=dir_names[k]
  print ('dir is '.. dir)
  jj=0
--  for name in paths.iterfiles(dir) do
  for name=1,30 do
  jj=jj+1
--name="freq"..k
    fileName='n' .. name
    print ("name is " .. fileName)
    file=io.open(paths.concat(dir,fileName),"r")
    
    str=file:read("*a")
    str=str:split('\n')
    soundData={}
    for lineNumber=1,#str do
      line=str[lineNumber]
      line=line:split(' ')
      --print(str)
      for key,value in pairs(line) do
        
        table.insert(soundData,tonumber(value)) 
      end
    end
    soundData=torch.Tensor(soundData)
--    maxim=torch.max(soundData)
--    print(soundData)
--    soundData=soundData/100
    --soundData=torch.abs(soundData)
--    print(type(soundData))
--    if(k<=10) then
--      label=1
--    elseif(k<=20) then
--      label=2
--    else
--      label=3
--    end
    
    
    if jj % 5 == 0 then
      createTestset(soundData,k)
    else
      createDataset(soundData,k)
    end
--    print ('end of '..fileName) 
  end
end

function createSimpleTest(x,y,z,label)
  acc={}
  for j=1,27 do
    table.insert(acc,0)
  end
  table.insert(acc,x)
  table.insert(acc,y)
  table.insert(acc,z)
  acc=torch.Tensor(acc)
  acc=acc/255
  createDataset(acc,label)
  createTestset(acc,label)
end

function realTest()
  -- load namespace
  local socket = require("socket")
  -- create a TCP socket and bind it to the local host, at any port
  local server = assert(socket.bind("*", 0))
  -- find out which port the OS chose for us
  local ip, port = server:getsockname()
  -- print a message informing what's up
  print("Please telnet to localhost on port " .. port)
  print("After connecting, you have 10s to enter a line to be echoed")
  -- loop forever waiting for clients
  while 1 do
    -- wait for a connection from any client
    local client = server:accept()
    print "some one is connected"
    -- make sure we don't block waiting for this client's line
  --  client:settimeout(10)
    -- receive the line
    local line, err = client:receive()
    print "something is received"
--    print ("line is " .. line)
    soundData={}
    str=line:split(' ')
    for key,value in pairs(str) do
      table.insert(soundData,tonumber(value)) 
    end
    soundData=torch.Tensor(soundData)
    createTestset(soundData,2)
    start_test()
    
    -- if there was no error, send it back to the client
    if not err then client:send(line .. "\n") end
    -- done with client, close the object
    client:close()
  end
end

--------------------
--
--file=io.open("cleanedData.txt","r")
--text=file:read("*a")
--text=text:split('\n')
--for key, var in ipairs(text) do
--      var=var:split(' ')
--      label=var[#var]
--      acc={}
--      for i=1, 27 do
--      	table.insert(acc,-400)
--      end
--      table.insert(acc,var[1])
--      table.insert(acc,var[2])
--      table.insert(acc,var[3])
--      
--      acc=torch.Tensor(acc)
----      print(acc)
--      acc=acc+400
--      acc=acc/800
--    if key <= train_size then
--      createDataset(acc,label)	
--    else
--      createTestset(acc,label)
--    end    
--end
